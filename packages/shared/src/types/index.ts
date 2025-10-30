// Core application types
export interface User {
  id: string;
  email: string;
  name: string;
  userType: 'member' | 'trainer' | 'admin' | 'nutritionist';
  tenantId?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface Tenant {
  id: string;
  name: string;
  logoUrl?: string;
  primaryColor: string;
  config: TenantConfig;
}

export interface TenantConfig {
  features: {
    nutrition: boolean;
    community: boolean;
    scheduling: boolean;
    whiteLabel: boolean;
  };
}

// API Response types
export interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Utility types
export type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;
export type Require<T, K extends keyof T> = T & Required<Pick<T, K>>;