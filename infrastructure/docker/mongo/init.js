// Fitness Combat Platform - MongoDB Initialization Script

// Switch to development database
db = db.getSiblingDB('fcp_dev');

// Create collections
db.createCollection('exercises');
db.createCollection('workouts');
db.createCollection('workout_logs');
db.createCollection('foods');
db.createCollection('meals');
db.createCollection('meal_logs');
db.createCollection('nutrition_goals');
db.createCollection('body_measurements');
db.createCollection('achievements');
db.createCollection('challenges');
db.createCollection('leaderboards');
db.createCollection('activity_feed');
db.createCollection('notifications');

// Create indexes for exercises
db.exercises.createIndex({ name: 'text', description: 'text' });
db.exercises.createIndex({ category: 1 });
db.exercises.createIndex({ muscleGroup: 1 });
db.exercises.createIndex({ equipment: 1 });
db.exercises.createIndex({ difficulty: 1 });
db.exercises.createIndex({ tenantId: 1 });

// Create indexes for foods
db.foods.createIndex({ name: 'text', brand: 'text' });
db.foods.createIndex({ barcode: 1 }, { unique: true, sparse: true });
db.foods.createIndex({ category: 1 });
db.foods.createIndex({ tenantId: 1 });

// Create indexes for meal logs
db.meal_logs.createIndex({ userId: 1, date: -1 });
db.meal_logs.createIndex({ userId: 1, mealType: 1 });
db.meal_logs.createIndex({ userId: 1, date: -1, mealType: 1 });

// Create indexes for workout logs
db.workout_logs.createIndex({ userId: 1, date: -1 });
db.workout_logs.createIndex({ userId: 1, workoutId: 1 });
db.workout_logs.createIndex({ userId: 1, exerciseId: 1 });

// Create indexes for activity feed
db.activity_feed.createIndex({ userId: 1, createdAt: -1 });
db.activity_feed.createIndex({ type: 1, createdAt: -1 });

// Create indexes for notifications
db.notifications.createIndex({ userId: 1, read: 1, createdAt: -1 });

// Insert sample exercises
db.exercises.insertMany([
  {
    name: 'Push-ups',
    description: 'Classic bodyweight exercise for chest, shoulders, and triceps',
    category: 'strength',
    muscleGroup: 'chest',
    equipment: 'bodyweight',
    difficulty: 'beginner',
    instructions: [
      'Start in plank position with hands shoulder-width apart',
      'Lower your body until chest nearly touches the floor',
      'Push back up to starting position',
      'Repeat for desired reps'
    ],
    tenantId: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: 'Squats',
    description: 'Fundamental lower body exercise',
    category: 'strength',
    muscleGroup: 'legs',
    equipment: 'bodyweight',
    difficulty: 'beginner',
    instructions: [
      'Stand with feet shoulder-width apart',
      'Lower your body by bending knees and hips',
      'Keep chest up and knees tracking over toes',
      'Lower until thighs are parallel to floor',
      'Push through heels to return to start'
    ],
    tenantId: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: 'Roundhouse Kick',
    description: 'Basic martial arts kick targeting side of opponent',
    category: 'martial-arts',
    muscleGroup: 'legs',
    equipment: 'none',
    difficulty: 'intermediate',
    instructions: [
      'Start in fighting stance',
      'Pivot on supporting foot',
      'Swing kicking leg in circular motion',
      'Strike with instep or shin',
      'Return to fighting stance'
    ],
    tenantId: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

// Insert sample foods
db.foods.insertMany([
  {
    name: 'Chicken Breast',
    category: 'protein',
    servingSize: { amount: 100, unit: 'g' },
    nutrition: {
      calories: 165,
      protein: 31,
      carbs: 0,
      fat: 3.6,
      fiber: 0,
      sugar: 0
    },
    barcode: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: 'Brown Rice',
    category: 'carbs',
    servingSize: { amount: 100, unit: 'g' },
    nutrition: {
      calories: 123,
      protein: 2.7,
      carbs: 26,
      fat: 1,
      fiber: 1.8,
      sugar: 0.4
    },
    barcode: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  },
  {
    name: 'Broccoli',
    category: 'vegetables',
    servingSize: { amount: 100, unit: 'g' },
    nutrition: {
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4,
      fiber: 2.6,
      sugar: 1.7
    },
    barcode: null,
    isPublic: true,
    createdAt: new Date(),
    updatedAt: new Date()
  }
]);

print('MongoDB initialization complete!');