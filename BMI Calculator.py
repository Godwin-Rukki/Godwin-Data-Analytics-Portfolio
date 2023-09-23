#BMI Calculator

# Function to calculate BMI
def calculate_bmi(weight_kg, height_m):
    return weight_kg / (height_m ** 2)

# Function to interpret BMI and provide advice
def interpret_bmi(bmi):
    if bmi < 18.5:
        return "Underweight", "You are underweight. Consider increasing your calorie intake and consulting a healthcare professional."
    elif 18.5 <= bmi < 24.9:
        return "Normal Weight", "Congratulations, you are within the normal weight range. Maintain a balanced diet and regular exercise."
    elif 25.0 <= bmi < 29.9:
        return "Overweight", "You are overweight. Focus on a healthy diet and exercise routine to lose weight."
    else:
        return "Obese", "You are in the obese category. Consult a healthcare professional for weight management."

# Input weight in kilograms and height in meters
weight = float(input("Enter your weight in kilograms: "))
height = float(input("Enter your height in meters: "))

# Calculate BMI
bmi = calculate_bmi(weight, height)

# Interpret BMI and provide advice
category, advice = interpret_bmi(bmi)

# Display results
print(f"Your BMI is {bmi:.2f}")
print(f"You are in the '{category}' category.")
print(advice)