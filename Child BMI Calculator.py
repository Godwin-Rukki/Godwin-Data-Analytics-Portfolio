# Function to calculate BMI-for-age percentiles for children and adolescents

def calculate_bmi_for_children(age_months, gender, height_cm, weight_kg):
    # Define BMI-for-age data for boys and girls (percentiles)
    # This data should be based on authoritative sources and can be more extensive
    bmi_data_boys = {
        (2, 3): [15.2, 13.7, 12.3, 10.8, 10.2],  # Example data, actual data should be used
        (4, 5): [15.0, 13.6, 12.1, 10.6, 10.0],  # Example data, actual data should be used
    }

    bmi_data_girls = {
        (2, 3): [14.9, 13.7, 12.2, 10.8, 10.3],  # Example data, actual data should be used
        (4, 5): [14.8, 13.6, 12.1, 10.7, 10.1],  # Example data, actual data should be used
    }

    # Determine the BMI-for-age percentile based on age, gender, height, and weight
    if gender.lower() == "male":
        bmi_data = bmi_data_boys
    elif gender.lower() == "female":
        bmi_data = bmi_data_girls
    else:
        return "Invalid gender input."

    # Find the appropriate age range
    age_range = None
    for key in bmi_data.keys():
        if key[0] <= age_months <= key[1]:
            age_range = key
            break

    if age_range is None:
        return "Age out of range for BMI calculation."

    # Calculate BMI-for-age percentile
    bmi_percentile = None
    height_m = height_cm / 100
    bmi = weight_kg / (height_m ** 2)

    # Example: Determine the percentile based on example data
    percentile_data = bmi_data[age_range]
    if bmi >= percentile_data[0]:
        bmi_percentile = "95th percentile or above"
    elif bmi >= percentile_data[1]:
        bmi_percentile = "85th percentile"
    elif bmi >= percentile_data[2]:
        bmi_percentile = "75th percentile"
    elif bmi >= percentile_data[3]:
        bmi_percentile = "50th percentile"
    else:
        bmi_percentile = "Below 50th percentile"

    return bmi_percentile

# Input user information
age_months = int(input("Enter the child's age in months: "))
gender = input("Enter the child's gender (male/female): ")
height_cm = float(input("Enter the child's height in centimeters: "))
weight_kg = float(input("Enter the child's weight in kilograms: "))

# Calculate BMI-for-age percentile
bmi_percentile = calculate_bmi_for_children(age_months, gender, height_cm, weight_kg)

# Display result
print(f"The child's BMI is at the {bmi_percentile}.")