CREATE TABLE Квартиры (
    ID_квартиры SERIAL PRIMARY KEY,
    Улица VARCHAR(255) NOT NULL,
    Номер_дома INTEGER NOT NULL,
    Номер_квартиры INTEGER NOT NULL,
    Площадь FLOAT NOT NULL,
    Количество_комнат INTEGER NOT NULL,
    UNIQUE (Улица, Номер_дома, Номер_квартиры)
);

CREATE TABLE Риэлторы (
    ID_риэлтора SERIAL PRIMARY KEY,
    ФИО VARCHAR(255) NOT NULL,
    Процент_вознаграждения FLOAT NOT NULL
);

CREATE TABLE Клиенты (
    ID_клиента SERIAL PRIMARY KEY,
    ФИО VARCHAR(255) NOT NULL,
    Контактная_информация VARCHAR(255) NOT NULL
);

CREATE TABLE Сделки (
    ID_сделки SERIAL PRIMARY KEY,
    Дата_сделки DATE NOT NULL,
    Цена_квартиры FLOAT NOT NULL,
    ID_квартиры INTEGER NOT NULL,
    ID_риэлтора INTEGER NOT NULL,
    FOREIGN KEY (ID_квартиры) REFERENCES Квартиры (ID_квартиры),
    FOREIGN KEY (ID_риэлтора) REFERENCES Риэлторы (ID_риэлтора)
);

CREATE TABLE Сделки_Клиенты (
    ID SERIAL PRIMARY KEY,
    ID_сделки INTEGER NOT NULL,
    ID_клиента INTEGER NOT NULL,
    Роль_клиента VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_сделки) REFERENCES Сделки (ID_сделки),
    FOREIGN KEY (ID_клиента) REFERENCES Клиенты (ID_клиента),
    UNIQUE (ID_сделки, ID_клиента)
);
