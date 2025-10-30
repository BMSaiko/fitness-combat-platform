// Simple TypeScript test file - React Native will be added later
export const appName = "Fitness Combat Platform Mobile";

export interface AppConfig {
  version: string;
  isDevelopment: boolean;
}

export const config: AppConfig = {
  version: "0.1.0",
  isDevelopment: true
};

// Utility function for future use
export const initializeApp = (): string => {
  return `${appName} v${config.version} initialized`;
};