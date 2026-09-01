/**
 * Netlify Serverless Function: Google Places Reviews Proxy
 * 
 * Securely queries Google Places API (Place Details) for Rainbow Eye Hospital
 * without exposing the API key on the client side.
 * 
 * Environment Variables required:
 *   - GOOGLE_PLACES_API_KEY: Your Google Cloud API Key with Places API enabled.
 *   - GOOGLE_PLACE_ID (Optional): Override Place ID if needed (e.g., 'ChIJ_1CMkU5dOTkRoCNp-TTnwNA').
 */

const https = require('https');

// Fallback Place query if no direct GOOGLE_PLACE_ID is supplied
const DEFAULT_PLACE_QUERY = 'Rainbow Eye Hospital, Opp. SVBN EM School, Kapparada, Madhavadhara, Visakhapatnam';
const DEFAULT_MAPS_URL = 'https://www.google.com/maps/place/Rainbow+Eye+Hospital/@17.7455424,83.2715274,991m/data=!3m2!1e3!4b1!4m6!3m5!1s0x3a395d4e918c50ff:0xd0c0e734f92923a0!8m2!3d17.7455424!4d83.2715274!16s%2Fg%2F11yd7vl0w7?entry=ttu';

function httpGet(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        try {
          const json = JSON.parse(data);
          resolve(json);
        } catch (e) {
          reject(new Error(`Failed to parse JSON from Google API: ${e.message}`));
        }
      });
    }).on('error', (err) => reject(err));
  });
}

exports.handler = async (event, context) => {
  const headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type',
    'Access-Control-Allow-Methods': 'GET, OPTIONS',
    'Content-Type': 'application/json',
    'Cache-Control': 'public, max-age=1800, s-maxage=3600', // Cache for 30-60 mins to optimize quota
  };

  if (event.httpMethod === 'OPTIONS') {
    return { statusCode: 204, headers, body: '' };
  }

  const apiKey = process.env.GOOGLE_PLACES_API_KEY;
  let placeId = process.env.GOOGLE_PLACE_ID;

  if (!apiKey) {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        status: 'API_KEY_NOT_CONFIGURED',
        message: 'GOOGLE_PLACES_API_KEY is not configured in environment variables. Using client fallback reviews.',
        hospitalName: 'Rainbow Eye Hospital',
        rating: 4.9,
        totalReviews: 248,
        googleMapsUrl: DEFAULT_MAPS_URL,
        reviews: [],
      }),
    };
  }

  try {
    // 1. If Place ID is not directly provided in env, resolve it via Find Place API
    if (!placeId) {
      const findUrl = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${encodeURIComponent(
        DEFAULT_PLACE_QUERY
      )}&inputtype=textquery&fields=place_id,name&key=${apiKey}`;

      const findRes = await httpGet(findUrl);
      if (findRes.candidates && findRes.candidates.length > 0) {
        placeId = findRes.candidates[0].place_id;
      }
    }

    // 2. Fetch Place Details with reviews and rating fields
    let placeDetailsUrl;
    if (placeId) {
      placeDetailsUrl = `https://maps.googleapis.com/maps/api/place/details/json?place_id=${placeId}&fields=name,rating,user_ratings_total,reviews,url&key=${apiKey}`;
    } else {
      // Fallback search
      placeDetailsUrl = `https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=${encodeURIComponent(
        DEFAULT_PLACE_QUERY
      )}&inputtype=textquery&fields=name,rating,user_ratings_total,reviews,url&key=${apiKey}`;
    }

    const detailsRes = await httpGet(placeDetailsUrl);

    if (detailsRes.status !== 'OK' || !detailsRes.result) {
      return {
        statusCode: 200,
        headers,
        body: JSON.stringify({
          status: detailsRes.status || 'ERROR',
          message: detailsRes.error_message || 'Could not fetch reviews from Google Places API',
          hospitalName: 'Rainbow Eye Hospital',
          rating: 4.9,
          totalReviews: 248,
          googleMapsUrl: DEFAULT_MAPS_URL,
          reviews: [],
        }),
      };
    }

    const result = detailsRes.result;
    const rawReviews = result.reviews || [];

    // Map into clean review items
    const reviews = rawReviews.map((r, index) => ({
      id: `google_${index + 1}`,
      authorName: r.author_name || 'Verified Patient',
      rating: typeof r.rating === 'number' ? r.rating : 5.0,
      text: r.text || '',
      relativeTimeDescription: r.relative_time_description || 'Recently',
      profilePhotoUrl: r.profile_photo_url || null,
      authorUrl: r.author_url || null,
      time: r.time,
    }));

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        status: 'OK',
        hospitalName: result.name || 'Rainbow Eye Hospital',
        rating: result.rating || 4.9,
        totalReviews: result.user_ratings_total || 250,
        googleMapsUrl: result.url || DEFAULT_MAPS_URL,
        placeId: placeId,
        reviewsCount: reviews.length,
        reviews: reviews,
      }),
    };
  } catch (err) {
    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        status: 'SERVERLESS_EXCEPTION',
        message: err.message,
        hospitalName: 'Rainbow Eye Hospital',
        rating: 4.9,
        totalReviews: 248,
        googleMapsUrl: DEFAULT_MAPS_URL,
        reviews: [],
      }),
    };
  }
};
