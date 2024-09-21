import pandas as pd
import matplotlib.pyplot as plt

def create_rating_diff_graph(input_file='player_rating_diff.csv', output_file='rating_diff.png'):
    # Read the CSV file
    df = pd.read_csv(input_file)

    # # Filter players with diff less than 1000
    # filtered_df = df[df['diff'] < -300]
    # # Sort the filtered dataframe by diff in descending order
    # filtered_df = filtered_df.sort_values('diff', ascending=False)
    # # Print the filtered and sorted data
    # print("Players with rating difference less than -300:")
    # print(filtered_df.to_string(index=False))
    # return

    # Calculate the quotient of diff divided by 100
    df['diff_quotient'] = df['diff'] // 100

    # Count the occurrences of each quotient
    quotient_counts = df['diff_quotient'].value_counts().sort_index()

    # Create a bar plot
    plt.figure(figsize=(12, 6))
    quotient_counts.plot(kind='bar')
    plt.title('Distribution of Rating Differences')
    plt.xlabel('Difference Range')
    plt.ylabel('Count')
    plt.xticks(rotation=45, ha='right')

    # Add value labels on top of each bar
    for i, v in enumerate(quotient_counts):
        plt.text(i, v, str(v), ha='center', va='bottom')

    # Modify x-axis labels to show ranges
    x_labels = [f'{i*100} to {(i+1)*100-1}' for i in quotient_counts.index]
    plt.gca().set_xticklabels(x_labels)

    # Save the plot
    plt.tight_layout()
    plt.savefig(output_file)
    plt.close()

    print(f"Graph has been saved as '{output_file}'")

if __name__ == "__main__":
    create_rating_diff_graph()
