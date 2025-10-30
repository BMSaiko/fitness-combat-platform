// Shared types and utilities

export interface User {
  id: string;
  email: string;
  name: string;
  userType: 'member' | 'trainer' | 'admin' | 'nutritionist';
}

export interface Exercise {
  id: string;
  name: string;
  category: string;
  description?: string;
}

// Utility functions
export const formatDate = (date: Date): string => {
  return date.toISOString().split('T')[0];
};