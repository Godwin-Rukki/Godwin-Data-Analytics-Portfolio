# Function to calculate daily calorie needs
def calculate_calories(age, gender, weight_kg, height_cm, activity_level):
   
    # Constants for calorie calculation
    BMR_CONST_MALE = 88.362
    BMR_CONST_FEMALE = 447.593
    BMR_CONST_ACTIVITY = {
        "sedentary": 1.2,
        "lightly_active": 1.375,
        "moderately_active": 1.55,
        "very_active": 1.725,
        "extra_active": 1.9,
    }

    # Calculate BMR (Basal Metabolic Rate)
    if gender.lower() == "male":
        bmr = BMR_CONST_MALE + (13.397 * weight_kg) + (4.799 * height_cm) - (5.677 * age)
    elif gender.lower() == "female":
        bmr = BMR_CONST_FEMALE + (9.247 * weight_kg) + (3.098 * height_cm) - (4.330 * age)
    else:
        return "Invalid gender input."

    # Calculate daily calorie needs based on activity level
    if activity_level.lower() in BMR_CONST_ACTIVITY:
        calorie_needs = bmr * BMR_CONST_ACTIVITY[activity_level.lower()]
        return calorie_needs
    else:
        return "Invalid activity level input."

# Input user information
age = int(input("Enter your age: "))
gender = input("Enter your gender (male/female): ")
weight_kg = float(input("Enter your weight in kilograms: "))
height_cm = float(input("Enter your height in centimeters: "))
activity_level = input("Enter your activity level (sedentary/lightly_active/moderately_active/very_active/extra_active): ")

# Calculate daily calorie needs
calorie_needs = calculate_calories(age, gender, weight_kg, height_cm, activity_level)

# Display results
print(f"Your estimated daily calorie needs are: {calorie_needs:.2f} calories")