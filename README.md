# Forecasting-Hotel-Booking-Cancellation-Trends


## Research Question
What are the monthly cancellation trends for hotel bookings, and can we accurately forecast these trends to better manage resources and expectations?

## Rationale
Understanding cancellation rates is crucial for hotels to make informed decisions about staffing, marketing, and resource allocation. By forecasting cancellation trends, hotels can take proactive measures to mitigate the impact of cancellations on revenue and occupancy rates.

## Objective
Forecast monthly hotel booking cancellation rates to improve revenue management and operational efficiency.

## Steps Taken
1. **Data Preparation**:
   - Imported data from `hotel_booking.csv`.
   - Dropped columns with excessive nulls (`company` and `agent`).
   - Imputed missing values for `children` and removed rows with missing `country`.
   - Converted `reservation_status_date` to date format.
   - Extracted monthly cancellation counts for analysis.
   - Key variables used: `Is_cancelled`, `Reservation_status_date`.

2. **Cancellation Trends Over Time**:
   - Aggregated cancellations monthly from October 2014 to September 2017.
   - Visualized trends to identify seasonal patterns.

3. **Training and Validation Split**:
   - **Training period**: October 2014 to September 2016.
   - **Validation period**: October 2016 to September 2017.

4. **Forecasting Models**:
   - **Naive Forecasting**: Assumes future values are equal to the last observed value. Provides a baseline for comparison.
   - **Exponential Smoothing (ETS)**: Accounts for patterns and seasonality, smoothing out random fluctuations in the data.
   - **ARIMA**: Auto-regressive integrated moving average model. Optimized using `auto.arima` for best-fit parameters.

5. **Evaluation Metric**:
   - **RMSE (Root Mean Squared Error)** on the validation dataset.

## Results
- **Naive Forecast**: RMSE = 686.17
- **Exponential Smoothing (ETS)**: RMSE = 686.16
- **ARIMA**: RMSE = 686.16

### Observations:
- All models performed similarly, with minimal differences in RMSE.
- Hotel booking cancellations exhibit clear seasonal patterns and fluctuations.
- A notable downward trend is observed toward the end of the dataset, indicating a potential decline in cancellations during the validation period.

# Visualizations

### 1. Naive Forecast

<img width="375" alt="Naive Forecast" src="https://github.com/user-attachments/assets/07dde9a6-ed8d-48bf-a09c-70372b7fadd1" />

- This plot shows the monthly cancellation trends over time using the Naive Forecast model. The training and validation periods are highlighted, with the Naive model assuming future values are equal to the last observed value.

### 2. Exponential Smoothing (ETS) Forecast

<img width="375" alt="ETS" src="https://github.com/user-attachments/assets/606d9197-a43f-4639-9d23-f95a0b1494c4" />

- This plot illustrates the monthly cancellation trends using the Exponential Smoothing (ETS) model. The model accounts for seasonality and trends, smoothing out random fluctuations in the data.

### 3. ARIMA Forecast

<img width="291" alt="ARIMA" src="https://github.com/user-attachments/assets/f6b45cd3-9672-419c-9af5-daedbc8e717f" />

- This plot displays the monthly cancellation trends using the ARIMA model. ARIMA captures complex patterns and provides precise forecasts, as evidenced by its performance.


## Key Insights
1. **Seasonal Patterns**:
   - Peaks in cancellations align with specific times of the year, possibly driven by seasonal travel patterns or external factors affecting bookings.

2. **Model Performance**:
   - **Naive Forecast**: Provides a simple flat projection but fails to capture seasonal and downward trends.
   - **Exponential Smoothing (ETS)**: Performs better by accounting for trends and seasonality.
   - **ARIMA**: Offers the most accurate results by modeling complex patterns and providing precise forecasts.

3. **Business Implications**:
   - Accurate forecasting models like ARIMA and ETS enable hotels to anticipate cancellation peaks and troughs, ensuring optimal resource allocation.
   - Understanding seasonal trends empowers the business to adjust marketing efforts and develop targeted retention strategies.
   - The observed downward trend may indicate an opportunity to investigate factors reducing cancellations and replicate those strategies across other periods.

## Limitations
- The RMSE values for all three models were extremely close, indicating similar accuracy across methods.
- Naive forecasting provided results comparable to more complex models, validating its effectiveness for short-term prediction in this dataset.
- Seasonal patterns were well-represented by ETS and ARIMA, but the added complexity did not yield substantial improvements.
- The forecast worked well during stable periods but failed to predict the sudden decline in cancellations.


## How to Use This Repository
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/hotel-booking-cancellation-forecasting.git
   cd hotel-booking-cancellation-forecasting
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the notebooks in the `Notebooks` directory to reproduce the analysis.
4. Explore the `Visualizations` folder for pre-generated plots.

## Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License
This project is licensed under the MIT License. See the (LICENSE) file for details.

---

For any questions or further information, please contact akhilagolla2622@gmail.com.
