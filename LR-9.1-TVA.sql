-- Запросы для тренировочного задания

-- Запрос для суммарной стоимости заказов по каждому клиенту
SELECT 
    c.FirstName, -- Имя клиента
    c.LastName, -- Фамилия клиента
    SUM(o.TotalAmount) AS TotalCustomerAmount -- Суммарная стоимость всех заказов клиента
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID -- Объединение таблиц Customers и Orders по CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName -- Группировка по уникальному идентификатору и имени, фамилии клиента
ORDER BY TotalCustomerAmount DESC; -- Сортировка по убыванию суммарной стоимости заказов

-- Добавление средней стоимости заказов для каждого клиента
SELECT 
    c.FirstName, -- Имя клиента
    c.LastName, -- Фамилия клиента
    SUM(o.TotalAmount) AS TotalCustomerAmount, -- Суммарная стоимость всех заказов клиента 
    AVG(o.TotalAmount) AS AverageOrderAmount -- Средняя стоимость одного заказа
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID -- Объединение таблиц Customers и Orders по CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName -- Группировка по уникальному идентификатору и имени, фамилии клиента
ORDER BY TotalCustomerAmount DESC; -- Сортировка по убыванию суммарной стоимости заказов

-- Клиент с максимальной суммарной стоимостью
WITH CustomerTotals AS ( -- Common Table Expression (CTE) обобщённое табличное выражение, считающее суммарную стоимость заказов по каждому клиенту
    SELECT 
        c.FirstName, -- Имя клиента
        c.LastName, -- Фамилия клиента
        SUM(o.TotalAmount) AS TotalCustomerAmount -- Суммарная стоимость всех заказов клиента 
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID -- Объединение таблиц Customers и Orders по CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName -- Группировка по уникальному идентификатору и имени, фамилии клиента
)
SELECT * 
FROM CustomerTotals
WHERE TotalCustomerAmount = (SELECT MAX(TotalCustomerAmount) FROM CustomerTotals); -- Фильтрация клиента с максимальной суммарной стоимостью

-- Заказы клиента с максимальной суммарной стоимостью
WITH CustomerTotals AS ( -- Подсчёт суммарной стоимости заказов для каждого клиента
    SELECT 
        c.CustomerID,
        SUM(o.TotalAmount) AS TotalCustomerAmount -- Суммарная стоимость всех заказов клиента 
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID -- Объединение таблиц Customers и Orders по CustomerID
    GROUP BY c.CustomerID -- Группировка по уникальному идентификатору
),
MaxCustomer AS ( -- Нахождение клиента с максимальной суммарной стоимостью заказов
    SELECT CustomerID FROM CustomerTotals
    WHERE TotalCustomerAmount = (SELECT MAX(TotalCustomerAmount) FROM CustomerTotals)
)
SELECT 
    o.OrderID, -- Номер заказа
    o.TotalAmount -- Сумма заказа
FROM Orders o
WHERE o.CustomerID IN (SELECT CustomerID FROM MaxCustomer) -- Фильтрация заказов по максимальному клиенту
ORDER BY o.TotalAmount ASC; -- Сортировка заказов по возрастанию стоимости

-- Клиенты с суммарной стоимостью заказов выше средней
WITH CustomerTotals AS ( -- Подсчёт суммарной стоимости заказов по каждому клиенту
    SELECT 
        c.FirstName,
        c.LastName,
        SUM(o.TotalAmount) AS TotalCustomerAmount
    FROM Customers c
    LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT 
    ct.FirstName, -- Имя клиента
    ct.LastName, -- Фамилия клиента
    ct.TotalCustomerAmount, -- Суммарная стоимость заказов клиента
    (SELECT AVG(TotalCustomerAmount) FROM CustomerTotals) AS AverageAmount -- Средняя сумма заказов
FROM CustomerTotals ct
WHERE ct.TotalCustomerAmount > (SELECT AVG(TotalCustomerAmount) FROM CustomerTotals); -- Условие: сумма больше средней
