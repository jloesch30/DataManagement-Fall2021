-- Author: Joshua Loesch
-- UTEID: jdl3876

-- This PL/SQL block will drop a table if it exists

DROP SEQUENCE customer_id_sequence;

DROP SEQUENCE feature_id_sequence;

DROP SEQUENCE location_id_sequence;

DROP SEQUENCE room_id_sequence;

DROP SEQUENCE payment_id_sequence;

DROP SEQUENCE reservation_id_sequence;

DROP TABLE reservation_details;

DROP TABLE location_features_linking;

DROP TABLE customer_payment;

DROP TABLE room;

DROP TABLE reservation;

DROP TABLE location;

DROP TABLE customer;

DROP TABLE features;

-- Creating the customer table

CREATE SEQUENCE customer_id_sequence START WITH 100001 INCREMENT BY 1;

CREATE TABLE customer (
    customer_id         NUMBER DEFAULT customer_id_sequence.NEXTVAL,
    first_name          VARCHAR(30) NOT NULL,
    last_name           VARCHAR(30) NOT NULL,
    email               VARCHAR(30) NOT NULL UNIQUE,
    phone               CHAR(12) NOT NULL,
    address_line_1      VARCHAR(30) NOT NULL,
    address_line_2      VARCHAR(30),
    city                VARCHAR(20) NOT NULL,
    state               CHAR(2) NOT NULL,
    zip                 CHAR(5) NOT NULL,
    birthdate           DATE,
    stay_credits_earned NUMBER DEFAULT 0,
    stay_credits_used   NUMBER DEFAULT 0,
    CONSTRAINT customers_pk PRIMARY KEY ( customer_id ),
    CONSTRAINT email_length_check CHECK ( length(email) >= 7 ),
    CONSTRAINT credits_verify CHECK ( stay_credits_used <= stay_credits_earned )
);
/

CREATE SEQUENCE feature_id_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE features (
    feature_id   NUMBER DEFAULT feature_id_sequence.NEXTVAL,
    feature_name VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT features_pk PRIMARY KEY ( feature_id )
);
/

CREATE SEQUENCE location_id_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE location (
    location_id   NUMBER DEFAULT location_id_sequence.NEXTVAL,
    location_name VARCHAR(20) NOT NULL UNIQUE,
    address       VARCHAR(200) NOT NULL,
    city          VARCHAR(20) NOT NULL,
    state         CHAR(2) NOT NULL,
    zip           CHAR(5) NOT NULL,
    phone         CHAR(12) NOT NULL,
    url           VARCHAR(200) NOT NULL,
    CONSTRAINT location_pk PRIMARY KEY ( location_id )
);
/

CREATE SEQUENCE room_id_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE room (
    room_id        NUMBER DEFAULT room_id_sequence.NEXTVAL,
    location_id    NUMBER NOT NULL,
    room_number    NUMBER NOT NULL,
    floor          NUMBER NOT NULL,
    room_type      CHAR(1) NOT NULL,
    square_footage NUMBER NOT NULL,
    max_people     NUMBER NOT NULL,
    weekday_rate   NUMBER NOT NULL,
    weekend_rate   NUMBER NOT NULL,
    CONSTRAINT room_pk PRIMARY KEY ( room_id ),
    CONSTRAINT room_location_fk FOREIGN KEY ( location_id )
        REFERENCES location ( location_id ),
    CONSTRAINT location_id_room_number_unique UNIQUE ( location_id,
                                                       room_number )
);
/

CREATE SEQUENCE payment_id_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE customer_payment (
    payment_id            NUMBER DEFAULT payment_id_sequence.NEXTVAL,
    customer_id           NUMBER NOT NULL, -- UNIQUE INDEX
    cardholder_first_name VARCHAR(30) NOT NULL,
    cardholder_mid_name   VARCHAR(30) NOT NULL,
    cardholder_last_name  VARCHAR(30) NOT NULL,
    cardtype              CHAR(4) NOT NULL,
    cardnumber            VARCHAR(30) NOT NULL,
    expiration_date       DATE NOT NULL,
    cc_id                 CHAR(3) NOT NULL,
    billing_address       VARCHAR(30) NOT NULL,
    billing_city          VARCHAR(30) NOT NULL,
    billing_state         CHAR(2) NOT NULL,
    billing_zip           CHAR(5) NOT NULL,
    CONSTRAINT customer_payment_pk PRIMARY KEY ( payment_id ),
    CONSTRAINT customer_payment_fk_customer FOREIGN KEY ( customer_id )
        REFERENCES customer ( customer_id )
);
/

CREATE SEQUENCE reservation_id_sequence START WITH 1 INCREMENT BY 1;

CREATE TABLE reservation (
    reservation_id    NUMBER DEFAULT reservation_id_sequence.NEXTVAL,
    customer_id       NUMBER NOT NULL,
    location_id       NUMBER NOT NULL,
    confirmation_nbr  VARCHAR(30) NOT NULL UNIQUE,
    date_created      DATE DEFAULT sysdate,
    check_in_date     DATE NOT NULL,
    check_out_date    DATE,
    status            CHAR(1) NOT NULL,
    number_of_guests  NUMBER NOT NULL,
    reservation_total NUMBER NOT NULL,
    discount_code     VARCHAR(30),
    customer_rating   NUMBER,
    notes             VARCHAR(200),
    CONSTRAINT reservation_pk PRIMARY KEY ( reservation_id ),
    CONSTRAINT reservation_customer_fk FOREIGN KEY ( customer_id )
        REFERENCES customer ( customer_id ),
    CONSTRAINT reservation_location_fk FOREIGN KEY ( location_id )
        REFERENCES location ( location_id )
);
/

-- Joint tables
CREATE TABLE location_features_linking (
    location_id NUMBER NOT NULL,
    feature_id  NUMBER NOT NULL,
    CONSTRAINT location_features_linking_pk PRIMARY KEY ( location_id,
                                                          feature_id ),
    CONSTRAINT lf_linking_location_fk FOREIGN KEY ( location_id )
        REFERENCES location ( location_id ),
    CONSTRAINT lf_linking_feature_fk FOREIGN KEY ( feature_id )
        REFERENCES features ( feature_id )
);
/

CREATE TABLE reservation_details (
    reservation_id NUMBER NOT NULL,
    room_id        NUMBER NOT NULL,
    CONSTRAINT reservation_details_pk PRIMARY KEY ( reservation_id,
                                                    room_id ),
    CONSTRAINT rd_reservation_fk FOREIGN KEY ( reservation_id )
        REFERENCES reservation ( reservation_id ),
    CONSTRAINT rd_room_fk FOREIGN KEY ( room_id )
        REFERENCES room ( room_id )
);
/

COMMIT;

-- create indexes
CREATE INDEX room_location_index ON
    room (
        location_id
    );

CREATE UNIQUE INDEX customer_payment_customer_index ON
    customer_payment (
        customer_id
    );

CREATE INDEX reservation_customer_index ON
    reservation (
        customer_id
    );

CREATE INDEX reservation_location_index ON
    reservation (
        location_id
    );
-- creating two other indexes
CREATE INDEX customer_lname_index ON
    customer (
        last_name
    );

CREATE INDEX customer_payment_lname_index ON
    customer_payment (
        cardholder_last_name
    );

COMMIT;

-- Inputing Locations
INSERT INTO location (
    location_name,
    address,
    city,
    state,
    zip,
    phone,
    url
) VALUES (
    'South Congress Hotel',
    '1234 South Congress blvd',
    'Austin',
    'TX',
    '78705',
    '129-234-2378',
    'www.fakeurl.com'
);

INSERT INTO location (
    location_name,
    address,
    city,
    state,
    zip,
    phone,
    url
) VALUES (
    'Cabins',
    '1234 Marble Falls',
    'Marble Falls',
    'TX',
    '78723',
    '129-234-2345',
    'www.fakeurlMarbleFalls.com'
);

INSERT INTO location (
    location_name,
    address,
    city,
    state,
    zip,
    phone,
    url
) VALUES (
    'Third Hotel',
    '1234 Fake Address',
    'Fake City',
    'TX',
    '78723',
    '129-234-9854',
    'www.fakeurlFakeHotel.com'
);

COMMIT;

-- Inserting features
INSERT INTO features ( feature_name ) VALUES ( 'Free WIFI' );

INSERT INTO features ( feature_name ) VALUES ( 'Dogs Allowed' );

INSERT INTO features ( feature_name ) VALUES ( 'No Smoking' );

-- Matching the locations with features
INSERT INTO location_features_linking (
    location_id,
    feature_id
) VALUES (
    1,
    1
);

INSERT INTO location_features_linking (
    location_id,
    feature_id
) VALUES (
    1,
    2
);

INSERT INTO location_features_linking (
    location_id,
    feature_id
) VALUES (
    2,
    2
);

INSERT INTO location_features_linking (
    location_id,
    feature_id
) VALUES (
    3,
    3
);

COMMIT;

-- Inserting rooms
INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    1,
    345,
    1,
    'D',
    123,
    4,
    199.99,
    250.99
);

INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    1,
    369,
    2,
    'K',
    456,
    2,
    199.99,
    250.99
);

INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    2,
    369,
    2,
    'K',
    456,
    2,
    199.99,
    250.99
);

INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    2,
    345,
    1,
    'D',
    123,
    4,
    199.99,
    250.99
);

INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    3,
    369,
    2,
    'K',
    456,
    2,
    199.99,
    250.99
);

INSERT INTO room (
    location_id,
    room_number,
    floor,
    room_type,
    square_footage,
    max_people,
    weekday_rate,
    weekend_rate
) VALUES (
    3,
    345,
    1,
    'D',
    123,
    4,
    199.99,
    250.99
);

COMMIT;

-- Inputing customers
INSERT INTO customer (
    first_name,
    last_name,
    email,
    phone,
    address_line_1,
    city,
    state,
    zip,
    birthdate
) VALUES (
    'Joshua',
    'Loesch',
    'jloesch30@utexas.edu',
    '713-555-5555',
    'Fake address 123',
    'Austin',
    'TX',
    '78705',
    '09-SEP-1998'
);

INSERT INTO customer (
    first_name,
    last_name,
    email,
    phone,
    address_line_1,
    city,
    state,
    zip,
    birthdate
) VALUES (
    'Fake',
    'Faker',
    'fake@utexas.edu',
    '713-555-fake',
    'Fake fake 123',
    'fake',
    'TX',
    '78705',
    '09-OCT-1998'
);

-- Input customer payment
INSERT INTO customer_payment (
    customer_id,
    cardholder_first_name,
    cardholder_mid_name,
    cardholder_last_name,
    cardtype,
    cardnumber,
    expiration_date,
    cc_id,
    billing_address,
    billing_city,
    billing_state,
    billing_zip
) VALUES (
    100001,
    'Fake',
    'Fake middle',
    'Faker',
    'VISA',
    '12312387123',
    '20-SEP-2022',
    '232',
    'fake address 123',
    'Austin',
    'TX',
    '78705'
);

INSERT INTO customer_payment (
    customer_id,
    cardholder_first_name,
    cardholder_mid_name,
    cardholder_last_name,
    cardtype,
    cardnumber,
    expiration_date,
    cc_id,
    billing_address,
    billing_city,
    billing_state,
    billing_zip
) VALUES (
    100002,
    'Fake2',
    'Fake middle2',
    'Faker2',
    'VISA',
    '1234897549387',
    '20-SEP-2027',
    '232',
    'fake address 123',
    'Austin',
    'TX',
    '78705'
);

COMMIT;

-- insert reservations
INSERT INTO reservation (
    customer_id,
    location_id,
    confirmation_nbr,
    date_created,
    check_in_date,
    check_out_date,
    status,
    number_of_guests,
    reservation_total,
    discount_code
) VALUES (
    100001,
    1,
    '12ash5362',
    '12-OCT-2021',
    '19-OCT-2021',
    '30-OCT-2021',
    'U',
    4,
    219.05,
    'HAPPY21'
);

INSERT INTO reservation (
    customer_id,
    location_id,
    confirmation_nbr,
    date_created,
    check_in_date,
    check_out_date,
    status,
    number_of_guests,
    reservation_total,
    discount_code
) VALUES (
    100002,
    2,
    '12esh9342',
    '12-OCT-2021',
    '19-OCT-2021',
    '31-OCT-2021',
    'U',
    4,
    219.05,
    'HAPPY21'
);

INSERT INTO reservation (
    customer_id,
    location_id,
    confirmation_nbr,
    date_created,
    check_in_date,
    check_out_date,
    status,
    number_of_guests,
    reservation_total,
    discount_code
) VALUES (
    100002,
    1,
    '12eshfj42',
    '12-NOV-2021',
    '19-NOV-2021',
    '28-NOV-2021',
    'U',
    4,
    219.05,
    'HAPPY21'
);

commit;