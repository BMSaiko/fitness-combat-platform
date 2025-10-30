export const formatDate = (date: Date): string => {
  const parts = date.toISOString().split('T');
  return parts[0] || date.toISOString(); // Garante que sempre retorne string
};

export const formatDateTime = (date: Date): string => {
  return date.toISOString();
};

export const isToday = (date: Date): boolean => {
  const today = new Date();
  return date.toDateString() === today.toDateString();
};

export const addDays = (date: Date, days: number): Date => {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
};