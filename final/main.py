import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error
from datetime import datetime

# Загрузка данных (замените этот код на чтение данных из API)
# В данном примере используется синтетический набор данных
data = pd.read_csv("weather_data.csv")

# Предобработка данных (возможно, потребуется дополнительная предобработка)
data['Date'] = pd.to_datetime(data['Date'])
data.set_index('Date', inplace=True)

# Визуализация данных
plt.figure(figsize=(10, 6))
sns.lineplot(x=data.index, y='Temperature', data=data)
plt.title('Temperature Over Time')
plt.xlabel('Date')
plt.ylabel('Temperature (Celsius)')
plt.show()

# Определение целевой переменной и признаков
X = data.drop('Temperature', axis=1)
y = data['Temperature']

# Разделение данных на обучающий и тестовый наборы
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Обучение модели машинного обучения (в данном случае, случайный лес)
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Предсказание на тестовом наборе
y_pred = model.predict(X_test)

# Оценка точности модели
mse = mean_squared_error(y_test, y_pred)
print(f"Mean Squared Error: {mse}")

# Пример использования обученной модели для прогнозирования температуры на следующий день
last_date = data.index[-1]
next_date = last_date + pd.DateOffset(days=1)
new_data = pd.DataFrame({'Feature1': [value], 'Feature2': [value]}, index=[next_date])
prediction = model.predict(new_data)
print(f"Temperature Prediction for {next_date}: {prediction[0]} Celsius")
