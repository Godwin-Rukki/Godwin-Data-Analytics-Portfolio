import time
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

CITY_DATA = { 
    'chicago': 'C:/Users/others/learning/chicago.csv',
    'new york city': 'C:/Users/others/learning/new_york_city.csv',
    'washington': 'C:/Users/others/learning/washington.csv' 
}

def get_user_name():
    """
    Asking user to input their namefor personaliztion.

    Returns:
           (str) user name - the name entered by the user
    """
    user_name = input('Hey There! Please enter your name: ')
    return user_name

def get_filters(user_name):
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello, {}! Let\'s explore some US bikeshare data!'.format(user_name))
    
    # Get user input for city (chicago, new york city, washington).
    while True:
        city = input('Enter the name of the city to analyze (chicago, new york city, washington): ').lower()
        if city in CITY_DATA:
            break
        else:
            print('Invalid city name. Please enter a valid city name.')

    # Get user input for month (all, january, february, ..., june).
    while True:
        month = input('Enter the name of the month to filter by (all, january, february, ..., june): ').lower()
        if month in ['all', 'january', 'february', 'march', 'april', 'may', 'june']:
            break
        else:
            print('Invalid month name. Please enter a valid month or "all".')

    # Get user input for day of the week (all, monday, tuesday, ..., sunday).
    while True:
        day = input('Enter the name of the day of the week to filter by (all, monday, tuesday, ..., sunday): ').lower()
        if day in ['all', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']:
            break
        else:
            print('Invalid day name. Please enter a valid day or "all".')

    print('-'*40)
    return city, month, day

def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    file_path = CITY_DATA[city]
    df = pd.read_csv(file_path)

    # Convert the 'Start Time' column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])

    # Filter by month if applicable
    if month != 'all':
        month_index = ['january', 'february', 'march', 'april', 'may', 'june'].index(month) + 1
        df = df[df['Start Time'].dt.month == month_index]

    # Filter by day of the week if applicable
    if day != 'all':
        day_index = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].index(day)
        df = df[df['Start Time'].dt.dayofweek == day_index]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    # Display the most common month
    print("Most common month: {}".format(df['Start Time'].dt.month.mode()[0]))

    # Display the most common day of week
    print("Most common day of week: {}".format(df['Start Time'].dt.dayofweek.mode()[0]))

    # Display the most common start hour
    print("Most common start hour: {}".format(df['Start Time'].dt.hour.mode()[0]))

    # Display Monthly Usage Trends (Line Chart)
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['Month'] = df['Start Time'].dt.month
    monthly_counts = df['Month'].value_counts().sort_index()

    plt.figure(figsize=(10, 6))
    plt.plot(monthly_counts.index, monthly_counts.values, marker='o')
    plt.title('Monthly Usage Trends')
    plt.xlabel('Month')
    plt.ylabel('Number of Rides')
    plt.xticks(monthly_counts.index)
    plt.grid()
    plt.show()

    # Day of the Week Usage (Bar Chart)
    df['Day of Week'] = df['Start Time'].dt.dayofweek
    day_counts = df['Day of Week'].value_counts().sort_index()
    days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']

    plt.figure(figsize=(10, 6))
    plt.bar(days, day_counts)
    plt.title('Day of the Week Usage')
    plt.xlabel('Day of the Week')
    plt.ylabel('Number of Rides')
    plt.xticks(rotation=45)
    plt.grid()
    plt.show()

    # Hourly Usage Patterns (Line Chart)
    df['Hour'] = df['Start Time'].dt.hour
    hourly_counts = df['Hour'].value_counts().sort_index()

    plt.figure(figsize=(10, 6))
    plt.plot(hourly_counts.index, hourly_counts.values, marker='o')
    plt.title('Hourly Usage Patterns')
    plt.xlabel('Hour of the Day')
    plt.ylabel('Number of Rides')
    plt.xticks(hourly_counts.index)
    plt.grid()
    plt.show()

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)

def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    # Display most commonly used start station
    print("Most commonly used start station: {}".format(df['Start Station'].mode()[0]))

    # Display most commonly used end station
    print("Most commonly used end station: {}".format(df['End Station'].mode()[0]))

    # Display most frequent combination of start station and end station trip
    station_combination = df.groupby(['Start Station', 'End Station']).size().idxmax()
    print("Most frequent combination of start station and end station trip: {} to {}".format(station_combination[0], station_combination[1]))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)

def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # Display total travel time
    print("Total travel time: {} seconds".format(df['Trip Duration'].sum()))

    # Display mean travel time
    print("Mean travel time: {} seconds".format(df['Trip Duration'].mean()))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)

def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # Display counts of user types
    user_type_counts = df['User Type'].value_counts()
    print("Counts of user types:")
    for user_type, count in user_type_counts.items():
        print("{}: {}".format(user_type, count))

    # Display counts of gender (if available in the data)
    if 'Gender' in df:
        gender_counts = df['Gender'].value_counts()
        print("\nCounts of gender:")
        for gender, count in gender_counts.items():
            print("{}: {}".format(gender, count))
    else:
        print("\nGender information not available in the selected dataset.")

    # Display earliest, most recent, and most common year of birth (if available in the data)
    if 'Birth Year' in df:
        earliest_birth_year = df['Birth Year'].min()
        most_recent_birth_year = df['Birth Year'].max()
        most_common_birth_year = df['Birth Year'].mode()[0]

        print("\nEarliest year of birth: {}".format(int(earliest_birth_year)))
        print("Most recent year of birth: {}".format(int(most_recent_birth_year)))
        print("Most common year of birth: {}".format(int(most_common_birth_year)))
    else:
        print("\nBirth year information not available in the selected dataset.")

    # Age Distribution of Users (Histogram, assuming 'Birth Year' is available)
    current_year = pd.Timestamp.now().year
    df['Age'] = current_year - df['Birth Year']

    plt.figure(figsize=(10, 6))
    plt.hist(df['Age'], bins=20, edgecolor='k')
    plt.title('Age Distribution of Users')
    plt.xlabel('Age')
    plt.ylabel('Number of Users')
    plt.grid()
    plt.show()

    # User Retention (Line Chart)
    df['Year'] = df['Start Time'].dt.year
    yearly_counts = df['Year'].value_counts().sort_index()

    plt.figure(figsize=(10, 6))
    plt.plot(yearly_counts.index, yearly_counts.values, marker='o')
    plt.title('User Retention Over Years')
    plt.xlabel('Year')
    plt.ylabel('Number of Rides')
    plt.xticks(yearly_counts.index)
    plt.grid()
    plt.show()
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)
    
    
    # displaying raw data
def display_data(df):
    chunk_size = 5
    start_loc = 0
    
    
    while start_loc < len(df):
        view_data = input('\nDo you want to see 5 rows of data? Enter yes or no.\n')
        if view_data.lower() != 'yes':
            break
            
        end_loc = start_loc + chunk_size
        if end_loc > len(df):
            end_loc = len(df)
            
        if start_loc == end_loc:
            print("No more data to display.")
            break
            
        print(df.iloc[start_loc:end_loc,: ])
        start_loc = end_loc

def main():
    while True:
        user_name = get_user_name()
        city, month, day = get_filters(user_name)
        df = load_data(city, month, day)

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        display_data(df)

        restart = input('\n{}, Would you like to view another city? Enter "yes" or "no": '.format(user_name))
        if restart.lower() != 'yes':
            break

if __name__ == "__main__":
    main()
    
