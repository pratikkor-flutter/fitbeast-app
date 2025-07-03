import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
import random

# Simulate sample dataset
np.random.seed(42)

def generate_sample_data(n=1000):
    data = []
    genders = ['Male', 'Female']
    diseases = [[], ['Diabetes'], ['Hypertension'], ['PCOS'], ['Diabetes', 'Hypertension'], []]
    goals = ['Weight Loss', 'Muscle Gain', 'Weight Maintenance']
    intensity_levels = ['Beginner', 'Intermediate', 'Advanced']
    diet_types = ['Veg', 'Non-Veg']

    for _ in range(n):
        weight = random.randint(45, 100)
        height = random.randint(150, 190)
        age = random.randint(18, 60)
        gender = random.choice(genders)
        disease = random.choice(diseases)
        goal = random.choice(goals)
        workout_days = random.randint(0, 7)
        intensity = random.choice(intensity_levels)
        diet = random.choice(diet_types)

        data.append([weight, height, age, gender, ','.join(disease), goal, workout_days, intensity, diet])

    columns = ['weight', 'height', 'age', 'gender', 'diseases', 'fitness_goal', 'workout_days', 'workout_level', 'diet_type']
    return pd.DataFrame(data, columns=columns)

df = generate_sample_data(1000)

# Preprocess features
X_raw = df.copy()
features_to_scale = ['weight', 'height', 'age', 'workout_days']
features_to_encode = ['gender', 'fitness_goal', 'workout_level', 'diet_type']

ct = ColumnTransformer([
    ('scale', StandardScaler(), features_to_scale),
    ('encode', OneHotEncoder(), features_to_encode)
], remainder='drop')

X_transformed = ct.fit_transform(X_raw)

# Step 3: Train KMeans 
kmeans = KMeans(n_clusters=10, random_state=42, n_init=10)
y_clusters = kmeans.fit_predict(X_transformed)

# Preprocess single input 
def preprocess_single_input(user_input):
    user_df = pd.DataFrame([user_input])
    return ct.transform(user_df)

# Clusters
cluster_templates = {
  "0_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": []
  },
  "0_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 2": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Buttermilk",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": []
  },
  "0_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": []
  },
  "0_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 6": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": []
  },
  "0_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": []
  },
  "0_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": []
  },
  "1_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Upma",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 6": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "15 min walking"
    ]
  },
  "1_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Upma",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": [
      "30 min brisk walk"
    ]
  },
  "1_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 3": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 4": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training"
    ]
  },
  "1_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 6": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": [
      "15 min walking"
    ]
  },
  "1_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 5": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      }
    },
    "workout_activities": [
      "30 min brisk walk"
    ]
  },
  "1_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 6": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training"
    ]
  },
  "2_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 6": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 7": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga"
    ]
  },
  "2_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min"
    ]
  },
  "2_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min"
    ]
  },
  "2_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 5": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga"
    ]
  },
  "2_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 6": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min"
    ]
  },
  "2_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 3": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min"
    ]
  },
  "3_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 3": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching"
    ]
  },
  "3_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 6": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell"
    ]
  },
  "3_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD"
    ]
  },
  "3_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching"
    ]
  },
  "3_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell"
    ]
  },
  "3_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD"
    ]
  },
  "4_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min"
    ]
  },
  "4_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength"
    ]
  },
  "4_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 5": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running"
    ]
  },
  "4_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 4": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Tandoori Chicken with Salad"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min"
    ]
  },
  "4_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength"
    ]
  },
  "4_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 4": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running"
    ]
  },
  "5_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 6": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises"
    ]
  },
  "5_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Upma",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training"
    ]
  },
  "5_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout"
    ]
  },
  "5_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 6": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises"
    ]
  },
  "5_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 3": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training"
    ]
  },
  "5_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout"
    ]
  },
  "6_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 2": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 3": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 5": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises",
      "Low impact aerobics"
    ]
  },
  "6_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 3": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 5": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 7": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training",
      "Jump rope 10 min + Squats"
    ]
  },
  "6_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Upma",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 2": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 3": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Sprouts Chat",
        "Dinner": "Vegetable Pulao"
      },
      "Day 4": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Upma",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 6": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Moong Dal Khichdi"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout",
      "Boxing circuit"
    ]
  },
  "6_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 5": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 6": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises",
      "Low impact aerobics"
    ]
  },
  "6_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 2": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 4": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 5": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 6": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training",
      "Jump rope 10 min + Squats"
    ]
  },
  "6_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 5": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Chicken Soup",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout",
      "Boxing circuit"
    ]
  },
  "7_Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 3": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 4": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Fruit Salad",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 6": {
        "Breakfast": "Poha",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Vegetable Pulao"
      },
      "Day 7": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Roasted Chana",
        "Dinner": "Dal Tadka with Roti"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises",
      "Low impact aerobics",
      "Slow cycling"
    ]
  },
  "7_Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Upma",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Buttermilk",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Upma",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      },
      "Day 5": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Fruit Salad",
        "Dinner": "Vegetable Pulao"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 7": {
        "Breakfast": "Poha",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Sprouts Chat",
        "Dinner": "Chapati with Paneer Curry"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training",
      "Jump rope 10 min + Squats",
      "Dance workout"
    ]
  },
  "7_Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Nuts Mix",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 2": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Dal Tadka with Roti"
      },
      "Day 3": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Chapati with Veg Curry",
        "Snacks": "Sprouts Chat",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 4": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Dal with Rice and Sabzi",
        "Snacks": "Nuts Mix",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 5": {
        "Breakfast": "Vegetable Dalia",
        "Lunch": "Rajma with Brown Rice",
        "Snacks": "Fruit Salad",
        "Dinner": "Moong Dal Khichdi"
      },
      "Day 6": {
        "Breakfast": "Oats with Milk",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Roasted Chana",
        "Dinner": "Chapati with Paneer Curry"
      },
      "Day 7": {
        "Breakfast": "Idli Sambhar",
        "Lunch": "Kadhi with Khichdi",
        "Snacks": "Nuts Mix",
        "Dinner": "Vegetable Pulao"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout",
      "Boxing circuit",
      "Powerlifting"
    ]
  },
  "7_Non-Veg_Beginner": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Protein Shake",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 7": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      }
    },
    "workout_activities": [
      "15 min walking",
      "20 min yoga",
      "10 min stretching",
      "Light cardio 15 min",
      "Breathing exercises",
      "Low impact aerobics",
      "Slow cycling"
    ]
  },
  "7_Non-Veg_Intermediate": {
    "diet": {
      "Day 1": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 2": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 4": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 5": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Fish Curry with Rice",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      },
      "Day 6": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Chicken Tikka with Veggies"
      },
      "Day 7": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Grilled Chicken with Rice",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      }
    },
    "workout_activities": [
      "30 min brisk walk",
      "HIIT 20 min",
      "Upper body dumbbell",
      "Lower body strength",
      "Core training",
      "Jump rope 10 min + Squats",
      "Dance workout"
    ]
  },
  "7_Non-Veg_Advanced": {
    "diet": {
      "Day 1": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Chicken Soup",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 2": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 3": {
        "Breakfast": "Chicken Sandwich",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Boiled Eggs",
        "Dinner": "Tandoori Chicken with Salad"
      },
      "Day 4": {
        "Breakfast": "Omelette with Paratha",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Protein Shake",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 5": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Chicken Biryani",
        "Snacks": "Greek Yogurt",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 6": {
        "Breakfast": "Egg Bhurji with Toast",
        "Lunch": "Chicken Biryani",
        "Snacks": "Boiled Eggs",
        "Dinner": "Egg Curry with Quinoa"
      },
      "Day 7": {
        "Breakfast": "Boiled Eggs with Brown Bread",
        "Lunch": "Egg Curry with Roti",
        "Snacks": "Greek Yogurt",
        "Dinner": "Fish Fry with Roti"
      }
    },
    "workout_activities": [
      "Heavy strength training",
      "HIIT 30 min",
      "Crossfit WOD",
      "Long distance running",
      "Full-body gym workout",
      "Boxing circuit",
      "Powerlifting"
    ]
  }
}

# Recommend plan using cluster metadata 
def recommend_plan(user_input_dict, kmeans_model, cluster_templates, X_train_raw, y_clusters):
    X_user = preprocess_single_input(user_input_dict)
    cluster_label = kmeans_model.predict(X_user)[0]

    # Get samples in the same cluster
    cluster_indices = [i for i, c in enumerate(y_clusters) if c == cluster_label]
    subset = X_train_raw.iloc[cluster_indices]

    if subset.empty:
        return "unknown", {"diet": {}, "workout_activities": []}

    # Most common metadata
    dominant_days = subset['workout_days'].mode()[0]
    dominant_diet_type = subset['diet_type'].mode()[0]
    dominant_level = subset['workout_level'].mode()[0]

    # Cluster key
    cluster_id = f"{dominant_days}_{dominant_diet_type}_{dominant_level}"
    plan = cluster_templates.get(cluster_id, {
        'diet': {},
        'workout_activities': []
    })

    return cluster_id, plan

# Test with single input 
test_user = {
    'weight': 70,
    'height': 175,
    'age': 25,
    'gender': 'Male',
    'diseases': 'None',
    'fitness_goal': 'Muscle Gain',
    'workout_days': 5,
    'workout_level': 'Intermediate',
    'diet_type': 'Veg'
}

cluster_used, recommended_plan = recommend_plan(test_user, kmeans, cluster_templates, X_raw, y_clusters)

print("Cluster Used:", cluster_used)
print("\nRecommended Diet Plan:")
for day, meals in recommended_plan["diet"].items():
    print(f"{day}: {meals}")
print("\nRecommended Workout Plan:")
for activity in recommended_plan["workout_activities"]:
    print(activity)


import joblib
joblib.dump(kmeans, "model.pkl")
joblib.dump(ct, "transformer.pkl")
X_raw.to_csv("X_raw.csv", index=False)
pd.DataFrame({'cluster': y_clusters}).to_csv("y_clusters.csv", index=False)
