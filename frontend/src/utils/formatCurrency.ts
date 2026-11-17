// src/utils/formatCurrency.ts

export type Currency = 'USD' | 'PYG' | 'BRL';

export const formatCurrency = (value: string | number, currencyCode: Currency): string => {
  // 1. Convierte a número. Solo el guaraní se redondea (no usa decimales);
  //    USD y BRL conservan los centavos.
  const parsed = typeof value === 'string' ? parseFloat(value) : value;
  const numberValue = currencyCode === 'PYG' ? Math.round(parsed) : Math.round(parsed * 100) / 100;

  // 2. Si el resultado no es un número, retorna 'N/A'
  if (isNaN(numberValue)) {
    return 'N/A';
  }

  // 3. Aplica el formato según la moneda de forma más directa
  switch (currencyCode) {
    case 'USD':
      // Formato para Dólares Americanos (2 decimales)
      return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
      }).format(numberValue);

    case 'PYG':
      // Formato para Guaraníes (sin decimales, con separador de miles)
      // Usamos toLocaleString que es excelente para esto
      return `₲ ${numberValue.toLocaleString('es-PY')}`;

    case 'BRL':
      // Formato para Reales Brasileños (2 decimales)
      return new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL',
      }).format(numberValue);

    default:
      return String(numberValue);
  }
};