export const APP_CONSTANTS = {
  APP_NAME: "Fitness Combat Platform",
  VERSION: "0.1.0",
  SUPPORTED_LANGUAGES: ["en", "pt", "es"] as const,
  DEFAULT_PAGE_SIZE: 20,
  MAX_FILE_SIZE: 5 * 1024 * 1024, // 5MB
} as const;

export const EXERCISE_CATEGORIES = {
  STRENGTH: "strength",
  CARDIO: "cardio",
  FLEXIBILITY: "flexibility",
  MARTIAL_ARTS: "martial_arts",
  FUNCTIONAL: "functional"
} as const;

export const NUTRIENT_TYPES = {
  PROTEIN: "protein",
  CARBS: "carbs",
  FAT: "fat",
  FIBER: "fiber",
  SUGAR: "sugar"
} as const;