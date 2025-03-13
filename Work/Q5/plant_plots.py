import argparse
import matplotlib.pyplot as plt

# Argument parsing
parser = argparse.ArgumentParser(description="Generate plant growth plots.")
parser.add_argument("--plant", type=str, required=True, help="Plant name")
parser.add_argument("--height", type=float, nargs="+", required=True, help="Height measurements")
parser.add_argument("--leaf_count", type=int, nargs="+", required=True, help="Leaf count measurements")
parser.add_argument("--dry_weight", type=float, nargs="+", required=True, help="Dry weight measurements")

args = parser.parse_args()

# Print plant data
print(f"Plant: {args.plant}")
print(f"Height data: {args.height} cm")
print(f"Leaf count data: {args.leaf_count}")
print(f"Dry weight data: {args.dry_weight} g")

# Scatter Plot - Height vs Leaf Count
plt.figure(figsize=(10, 6))
plt.scatter(args.height, args.leaf_count, color='b')
plt.title(f'Height vs Leaf Count for {args.plant}')
plt.xlabel('Height (cm)')
plt.ylabel('Leaf Count')
plt.grid(True)
plt.savefig(f"{args.plant}_scatter.png")
plt.close()

# Histogram - Distribution of Dry Weight
plt.figure(figsize=(10, 6))
plt.hist(args.dry_weight, bins=5, color='g', edgecolor='black')
plt.title(f'Histogram of Dry Weight for {args.plant}')
plt.xlabel('Dry Weight (g)')
plt.ylabel('Frequency')
plt.grid(True)
plt.savefig(f"{args.plant}_histogram.png")
plt.close()

# Line Plot - Plant Height Over Time
plt.figure(figsize=(10, 6))
weeks = [f'Week {i+1}' for i in range(len(args.height))]
plt.plot(weeks, args.height, marker='o', color='r')
plt.title(f'{args.plant} Height Over Time')
plt.xlabel('Week')
plt.ylabel('Height (cm)')
plt.grid(True)
plt.savefig(f"{args.plant}_line_plot.png")
plt.close()
