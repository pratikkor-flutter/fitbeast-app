from flask import Flask, request, jsonify
import joblib
import pandas as pd
from clusters import cluster_templates

# Load model and transformer
kmeans = joblib.load("model.pkl")
transformer = joblib.load("transformer.pkl")
X_raw = pd.read_csv("X_raw.csv")  # Store raw training data used for clustering
y_clusters = pd.read_csv("y_clusters.csv")['cluster'].values

app = Flask(__name__)

# Preprocessing helper
def preprocess_input(user_input):
    df = pd.DataFrame([user_input])
    return transformer.transform(df)

@app.route('/recommend', methods=['POST'])
def recommend_plan():
    user_input = request.get_json()
    
    # Predict cluster
    X_user = preprocess_input(user_input)
    cluster_label = kmeans.predict(X_user)[0]

    # Get cluster key
    cluster_indices = [i for i, c in enumerate(y_clusters) if c == cluster_label]
    subset = X_raw.iloc[cluster_indices]

    if subset.empty:
        return jsonify({"error": "No matching cluster"}), 404

    dominant_days = subset['workout_days'].mode()[0]
    dominant_diet_type = subset['diet_type'].mode()[0]
    dominant_level = subset['workout_level'].mode()[0]

    cluster_key = f"{dominant_days}_{dominant_diet_type}_{dominant_level}"
    plan = cluster_templates.get(cluster_key, {
        "diet": {},
        "workout_activities": []
    })

    return jsonify({
        "cluster_key": cluster_key,
        "diet_plan": plan['diet'],
        "workout_plan": plan['workout_activities']
    })

if __name__ == '__main__':
    app.run(debug=True)
