CREATE TABLE Customer(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Email VARCHAR(200) NOT NULL UNIQUE,
    Phone VARCHAR(30) NULL,
    Document VARCHAR(20) NOT NULL UNIQUE,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()

    -- Criar CONSTRAINT para Email

    -- Ver se devemos criar CONSTRAINT para Document
);

CREATE TABLE Category(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Description VARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Product(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    CategoryId UNIQUEIDENTIFIER NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Description VARCHAR(500) NULL,
    Price NUMERIC(18, 2) NOT NULL,
    StockQuantity INT NOT NULL,
    MinimumStockQuantity INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT FK_CategoryId
        FOREIGN KEY (CategoryId)
        REFERENCES Category(Id),

    CONSTRAINT CK_Price
        CHECK (Price > 0),

    CONSTRAINT CK_StockQuantity
        CHECK (StockQuantity >= 0),

    CONSTRAINT CK_MinimumStockQuantity
        CHECK (MinimumStockQuantity >= 0)
);

CREATE TABLE Employee(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Email VARCHAR(200) NOT NULL,
    Document VARCHAR(20) NOT NULL UNIQUE,
    Role VARCHAR(50) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()

    CONSTRAINT CK_Role
        CHECK(Role IN('SalesPerson', 'Manager', 'Admin'))
);

CREATE TABLE Orders(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    CustomerId UNIQUEIDENTIFIER NOT NULL,
    EmployeeId UNIQUEIDENTIFIER NOT NULL,
    Name VARCHAR(200) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    TotalAmount NUMERIC(18, 2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_CustomerId
        FOREIGN KEY (CustomerId)
        REFERENCES Customer(Id),

    CONSTRAINT FK_EmployeeId
        FOREIGN KEY (EmployeeId)
        REFERENCES Employee(Id),

    CONSTRAINT CK_Status
        CHECK (Status IN('Created', 'Paid', 'Cancelled')),

    CONSTRAINT CK_TotalAmount
        CHECK (TotalAmount >= 0)
);

CREATE TABLE OrderItem(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    OrderId UNIQUEIDENTIFIER NOT NULL,
    ProductId UNIQUEIDENTIFIER NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice NUMERIC(18, 2) NOT NULL,
    TotalPrice NUMERIC(18, 2) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME2 NULL,

    CONSTRAINT FK_OrderId
        FOREIGN KEY (OrderId)
        REFERENCES Orders(Id),

    CONSTRAINT FK_ProductId
        FOREIGN KEY (ProductId)
        REFERENCES Product(Id),

    CONSTRAINT CK_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_UnitPrice
        CHECK (UnitPrice > 0),

    CONSTRAINT CK_TotalPrice
        CHECK (TotalPrice >= 0)
);

CREATE TABLE Payment(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    OrderId UNIQUEIDENTIFIER NOT NULL,
    PaymentMethod VARCHAR(50) NOT NULL,
    Amount NUMERIC(18, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    PaidAt DATETIME2 NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_OrderId
        FOREIGN KEY (OrderId)
        REFERENCES Orders(Id),

    CONSTRAINT CK_PaymentMethod
        CHECK (PaymentMethod IN ('CreditCard', 'DebitCard', 'Pix', 'Cash', 'BankSlip')),

    CONSTRAINT CK_Amount
        CHECK (Amount > 0),

    CONSTRAINT CK_Status
        CHECK (Status IN ('Pending', 'Paid', 'Cancelled', 'Refunded'))
);

CREATE TABLE StockMovements(
    Id UNIQUEIDENTIFIER PRIMARY KEY NOT NULL,
    ProductId UNIQUEIDENTIFIER NOT NULL,
    MovementType VARCHAR(50) NOT NULL,
    Quantity INT NOT NULL,
    Description VARCHAR(500) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_ProductId
        FOREIGN KEY (ProductId)
        REFERENCES Product(Id),

    CONSTRAINT CK_MovementType
        CHECK (MovementType IN ('IN', 'OUT', 'Adjustment', 'Return', 'Initial')),

    CONSTRAINT CK_Quantity
        CHECK (Quantity > 0)
);