import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

interface RateCache {
  rates: {
    PYG: number;
    BRL: number;
  } | null;
  timestamp: number;
}

let cachedRates: RateCache = {
  rates: null,
  timestamp: 0,
};

const CACHE_DURATION_MS = 6 * 60 * 60 * 1000;

export const getExchangeRates = async () => {
  const now = Date.now();

  if (cachedRates.rates && (now - cachedRates.timestamp < CACHE_DURATION_MS)) {
    console.log('[BACKEND] Usando tasas de cambio desde la caché.');
    return cachedRates.rates;
  }

  // Fuentes en orden de preferencia: la API con clave (si está configurada)
  // y, como respaldo, la API pública sin clave del mismo proveedor.
  const apiKey = process.env.EXCHANGE_RATE_API_KEY?.trim();
  const sources: { name: string; url: string; field: 'conversion_rates' | 'rates' }[] = [];
  if (apiKey && apiKey.toLowerCase() !== 'none') {
    sources.push({ name: 'ExchangeRate-API', url: `https://v6.exchangerate-api.com/v6/${apiKey}/latest/USD`, field: 'conversion_rates' });
  }
  sources.push({ name: 'open.er-api.com (sin clave)', url: 'https://open.er-api.com/v6/latest/USD', field: 'rates' });

  for (const source of sources) {
    try {
      console.log(`[BACKEND] Obteniendo tasas de cambio desde ${source.name}...`);
      const response = await axios.get(source.url, { timeout: 8000 });
      const ratesData = response.data?.[source.field];

      if (!ratesData?.PYG || !ratesData?.BRL) {
        throw new Error('La respuesta no contiene las monedas requeridas (PYG, BRL).');
      }

      cachedRates = {
        rates: { PYG: ratesData.PYG, BRL: ratesData.BRL },
        timestamp: now,
      };
      return cachedRates.rates;
    } catch (error) {
      console.error(`Error al obtener tasas de cambio desde ${source.name}:`, (error as Error).message);
    }
  }

  // Si todas las fuentes fallan, usar la última cotización conocida
  if (cachedRates.rates) {
    return cachedRates.rates;
  }
  throw new Error('No se pudieron obtener las tasas de cambio.');
};