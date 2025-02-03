import sys
import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt

def main():
    # Python version
    print(f"Python version: {sys.version}")
    
    # NumPy version and simple operation
    print(f"\nNumPy version: {np.__version__}")
    arr = np.array([1, 2, 3, 4, 5])
    print(f"NumPy array: {arr}")
    print(f"Mean: {arr.mean()}")
    
    # Pandas version and simple operation
    print(f"\nPandas version: {pd.__version__}")
    df = pd.DataFrame({
        'A': np.random.randn(5),
        'B': np.random.randn(5)
    })
    print("\nPandas DataFrame:")
    print(df)
    
    # Matplotlib version and simple plot
    print(f"\nMatplotlib version: {matplotlib.__version__}")
    plt.figure(figsize=(8, 6))
    plt.plot(df['A'], label='A')
    plt.plot(df['B'], label='B')
    plt.title('Test Plot')
    plt.legend()
    plt.savefig('test_plot.png')
    plt.close()
    print("\nPlot saved as 'test_plot.png'")

if __name__ == "__main__":
    main()
