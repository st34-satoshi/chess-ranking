import pandas as pd
import matplotlib.pyplot as plt

def create_rating_diff_graph(input_file='player_rating_diff.csv', output_file='rating_diff.png'):
    # Read the CSV file
    df = pd.read_csv(input_file)

    # Calculate the quotient of diff divided by 100
    df['diff_quotient'] = df['diff'] // 100

    # Count the occurrences of each quotient
    quotient_counts = df['diff_quotient'].value_counts().sort_index()

    # Create a bar plot
    plt.figure(figsize=(12, 6))
    quotient_counts.plot(kind='bar')
    plt.title('Distribution of Rating Differences')
    plt.xlabel('Difference Quotient (diff / 100)')
    plt.ylabel('Count')
    plt.xticks(rotation=0)

    # Add value labels on top of each bar
    for i, v in enumerate(quotient_counts):
        plt.text(i, v, str(v), ha='center', va='bottom')

    # Save the plot
    plt.tight_layout()
    plt.savefig(output_file)
    plt.close()

    print(f"Graph has been saved as '{output_file}'")

if __name__ == "__main__":
    create_rating_diff_graph()
