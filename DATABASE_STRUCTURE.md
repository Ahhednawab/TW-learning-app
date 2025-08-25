# TW Learning App - Required Database Structure

## Firebase Firestore Collections

### 1. **users** Collection
```
users/{userId}
{
  "profile": {
    "displayName": "John Doe",
    "email": "john@example.com",
    "profileImageUrl": "https://...",
    "preferredLanguage": "en",
    "createdAt": "2024-01-01T00:00:00Z",
    "lastLoginAt": "2024-01-01T00:00:00Z"
  },
  "settings": {
    "notificationsEnabled": true,
    "soundEnabled": true,
    "theme": "light"
  },
  "statistics": {
    "totalWordsLearned": 0,
    "totalQuizzesTaken": 0,
    "currentStreak": 0,
    "longestStreak": 0
  }
}
```

### 2. **levels** Collection
```
levels/{levelId}
{
  "levelId": "level_1",
  "name": "Beginner",
  "description": "Basic Chinese characters and words",
  "order": 1,
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 3. **categories** Collection
```
categories/{categoryId}
{
  "categoryId": "animals",
  "levelId": "level_1",
  "name": "Animals",
  "description": "Learn animal names in Chinese",
  "imageUrl": "https://example.com/animals.jpg",
  "order": 1,
  "totalWords": 20,
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 4. **words** Collection
```
words/{wordId}
{
  "wordId": "word_001",
  "categoryId": "animals",
  "traditional": "狗",
  "simplified": "狗",
  "pinyin": "gǒu",
  "english": "dog",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 8,
  "imageUrl": "https://example.com/dog.jpg",
  "audioUrl": "https://example.com/dog.mp3",
  "exampleSentence": {
    "traditional": "我有一隻狗。",
    "simplified": "我有一只狗。",
    "pinyin": "Wǒ yǒu yī zhī gǒu.",
    "english": "I have a dog."
  },
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

### 5. **user_progress** Collection
```
user_progress/{userId}/categories/{categoryId}/words/{wordId}
{
  "knownStatus": "learning", // "unknown", "learning", "known"
  "lastReviewed": "2024-01-01T00:00:00Z",
  "reviewCount": 3,
  "correctAnswers": 2,
  "totalAnswers": 3,
  "isFavorite": false
}
```

### 6. **user_activities** Collection
```
user_activities/{userId}/categories/{categoryId}/activities/{activityType}
{
  "activityType": "quiz", // "quiz", "swipeCards", "fillBlanks", "characterMatching", "listening"
  "isCompleted": false,
  "completedAt": null,
  "score": 0,
  "timeSpent": 0, // in minutes
  "lastAttemptAt": "2024-01-01T00:00:00Z"
}
```

### 7. **quiz_sessions** Collection
```
quiz_sessions/{sessionId}
{
  "sessionId": "session_001",
  "userId": "user_123",
  "categoryId": "animals",
  "levelId": "level_1",
  "questions": [
    {
      "wordId": "word_001",
      "question": "What does 狗 mean?",
      "options": ["A. Cat", "B. Dog", "C. Bird", "D. Fish"],
      "correctAnswer": 1,
      "userAnswer": 1,
      "isCorrect": true
    }
  ],
  "totalQuestions": 10,
  "correctAnswers": 8,
  "score": 80,
  "timeSpent": 5, // in minutes
  "completedAt": "2024-01-01T00:00:00Z",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### 8. **favorites** Collection
```
favorites/{userId}/words/{wordId}
{
  "wordId": "word_001",
  "categoryId": "animals",
  "addedAt": "2024-01-01T00:00:00Z"
}
```

## Sample Data to Add

### Sample Levels
```javascript
// Add to levels collection
{
  "levelId": "level_1",
  "name": "Beginner",
  "description": "Basic Chinese characters and words",
  "order": 1,
  "isActive": true,
  "createdAt": new Date()
}

{
  "levelId": "level_2", 
  "name": "Intermediate",
  "description": "More complex words and phrases",
  "order": 2,
  "isActive": true,
  "createdAt": new Date()
}
```

### Sample Categories
```javascript
// Add to categories collection
{
  "categoryId": "animals",
  "levelId": "level_1",
  "name": "Animals",
  "description": "Learn animal names in Chinese",
  "imageUrl": "assets/images/cat.jpg",
  "order": 1,
  "totalWords": 10,
  "isActive": true,
  "createdAt": new Date()
}

{
  "categoryId": "colors",
  "levelId": "level_1", 
  "name": "Colors",
  "description": "Learn color names in Chinese",
  "imageUrl": "assets/images/bird.jpg",
  "order": 2,
  "totalWords": 8,
  "isActive": true,
  "createdAt": new Date()
}

{
  "categoryId": "family",
  "levelId": "level_1",
  "name": "Family",
  "description": "Learn family member names",
  "imageUrl": "assets/images/chicken.webp",
  "order": 3,
  "totalWords": 12,
  "isActive": true,
  "createdAt": new Date()
}
```

### Sample Words (Animals Category)
```javascript
// Add to words collection
{
  "wordId": "word_001",
  "categoryId": "animals",
  "traditional": "狗",
  "simplified": "狗",
  "pinyin": "gǒu",
  "english": "dog",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 8,
  "imageUrl": "assets/images/dog.mp3",
  "audioUrl": "assets/audio/dog.mp3",
  "exampleSentence": {
    "traditional": "我有一隻狗。",
    "simplified": "我有一只狗。",
    "pinyin": "Wǒ yǒu yī zhī gǒu.",
    "english": "I have a dog."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}

{
  "wordId": "word_002",
  "categoryId": "animals",
  "traditional": "貓",
  "simplified": "猫",
  "pinyin": "māo",
  "english": "cat",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 7,
  "imageUrl": "assets/images/cat.jpg",
  "audioUrl": "assets/audio/cat.mp3",
  "exampleSentence": {
    "traditional": "貓很可愛。",
    "simplified": "猫很可爱。",
    "pinyin": "Māo hěn kě'ài.",
    "english": "The cat is very cute."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}

{
  "wordId": "word_003",
  "categoryId": "animals",
  "traditional": "鳥",
  "simplified": "鸟",
  "pinyin": "niǎo",
  "english": "bird",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 6,
  "imageUrl": "assets/images/bird.jpg",
  "audioUrl": "assets/audio/bird.mp3",
  "exampleSentence": {
    "traditional": "天空中有一隻鳥。",
    "simplified": "天空中有一只鸟。",
    "pinyin": "Tiānkōng zhōng yǒu yī zhī niǎo.",
    "english": "There is a bird in the sky."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}

{
  "wordId": "word_004",
  "categoryId": "animals",
  "traditional": "魚",
  "simplified": "鱼",
  "pinyin": "yú",
  "english": "fish",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 7,
  "imageUrl": "assets/images/fish.png",
  "audioUrl": "assets/audio/fish.mp3",
  "exampleSentence": {
    "traditional": "我喜歡吃魚。",
    "simplified": "我喜欢吃鱼。",
    "pinyin": "Wǒ xǐhuān chī yú.",
    "english": "I like to eat fish."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}

{
  "wordId": "word_005",
  "categoryId": "animals",
  "traditional": "雞",
  "simplified": "鸡",
  "pinyin": "jī",
  "english": "chicken",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 6,
  "imageUrl": "assets/images/chicken.webp",
  "audioUrl": "assets/audio/chicken.mp3",
  "exampleSentence": {
    "traditional": "農場有很多雞。",
    "simplified": "农场有很多鸡。",
    "pinyin": "Nóngchǎng yǒu hěn duō jī.",
    "english": "The farm has many chickens."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}
```

### Sample Words (Colors Category)
```javascript
{
  "wordId": "word_101",
  "categoryId": "colors",
  "traditional": "紅色",
  "simplified": "红色",
  "pinyin": "hóngsè",
  "english": "red",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 8,
  "imageUrl": "assets/images/red.png",
  "audioUrl": "assets/audio/red.mp3",
  "exampleSentence": {
    "traditional": "這朵花是紅色的。",
    "simplified": "这朵花是红色的。",
    "pinyin": "Zhè duǒ huā shì hóngsè de.",
    "english": "This flower is red."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}

{
  "wordId": "word_102",
  "categoryId": "colors",
  "traditional": "藍色",
  "simplified": "蓝色",
  "pinyin": "lánsè",
  "english": "blue",
  "partOfSpeech": "noun",
  "difficulty": 1,
  "frequency": 7,
  "imageUrl": "assets/images/blue.png",
  "audioUrl": "assets/audio/blue.mp3",
  "exampleSentence": {
    "traditional": "天空是藍色的。",
    "simplified": "天空是蓝色的。",
    "pinyin": "Tiānkōng shì lánsè de.",
    "english": "The sky is blue."
  },
  "createdAt": new Date(),
  "updatedAt": new Date()
}
```

## Firebase Setup Instructions

1. **Create Firebase Project**
   - Go to Firebase Console
   - Create new project
   - Enable Firestore Database
   - Set up Authentication (Email/Password)

2. **Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // User progress is private to each user
    match /user_progress/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // User activities are private to each user  
    match /user_activities/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Quiz sessions are private to each user
    match /quiz_sessions/{sessionId} {
      allow read, write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Favorites are private to each user
    match /favorites/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public read access for app content
    match /levels/{document} {
      allow read: if request.auth != null;
    }
    
    match /categories/{document} {
      allow read: if request.auth != null;
    }
    
    match /words/{document} {
      allow read: if request.auth != null;
    }
  }
}
```

3. **Add Sample Data**
   - Use Firebase Console or Admin SDK to add the sample data above
   - Ensure all collections have proper indexes for queries
   - Test with a few users to verify data structure

## Required Indexes

Create these composite indexes in Firestore:

1. **words collection**: `categoryId` (Ascending) + `createdAt` (Descending)
2. **categories collection**: `levelId` (Ascending) + `order` (Ascending)
3. **quiz_sessions collection**: `userId` (Ascending) + `createdAt` (Descending)
4. **user_progress collection**: `userId` (Ascending) + `lastReviewed` (Descending)

This database structure will support all the app's functionality including user progress tracking, quiz sessions, favorites management, and learning activities.
