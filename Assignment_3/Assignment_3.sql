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

CREATE SEQUENCE customer_id_sequence MINVALUE 100001 START WITH 100001 INCREMENT BY 1;

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

CREATE SEQUENCE feature_id_sequence MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE features (
    feature_id   NUMBER DEFAULT feature_id_sequence.NEXTVAL,
    feature_name VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT features_pk PRIMARY KEY ( feature_id )
);
/

CREATE SEQUENCE location_id_sequence MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE location (
    location_id   NUMBER DEFAULT location_id_sequence.NEXTVAL,
    location_name VARCHAR(20) NOT NULL UNIQUE,
    address       VARCHAR(20) NOT NULL,
    city          VARCHAR(20) NOT NULL,
    state         CHAR(2) NOT NULL,
    zip           CHAR(5) NOT NULL,
    phone         CHAR(12) NOT NULL,
    url           VARCHAR(20) NOT NULL,
    CONSTRAINT location_pk PRIMARY KEY ( location_id )
);
/

CREATE SEQUENCE room_id_sequence MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE room (
    room_id        NUMBER DEFAULT room_id_sequence.NEXTVAL,
    location_id    NUMBER NOT NULL,
    room_number    NUMBER NOT NULL,
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

CREATE SEQUENCE payment_id_sequence MINVALUE 1 START WITH 1 INCREMENT BY 1;

CREATE TABLE customer_payment (
    payment_id             NUMBER DEFAULT payment_id_sequence.NEXTVAL,
    customer_id            NUMBER NOT NULL, -- UNIQUE INDEX
    cardholder_first_name  VARCHAR(30) NOT NULL,
    cardholder_middle_name VARCHAR(30) NOT NULL,
    cardholder_last_name   VARCHAR(30) NOT NULL,
    cardtype               CHAR(4) NOT NULL,
    cardnumber             VARCHAR(30) NOT NULL,
    expiration_date        DATE NOT NULL,
    cc_id                  CHAR(3) NOT NULL,
    billing_address        VARCHAR(30) NOT NULL,
    billing_city           VARCHAR(30) NOT NULL,
    billing_state          CHAR(2) NOT NULL,
    billing_zip            CHAR(5) NOT NULL,
    CONSTRAINT customer_payment_pk PRIMARY KEY ( payment_id ),
    CONSTRAINT customer_payment_fk_customer FOREIGN KEY ( customer_id )
        REFERENCES customer ( customer_id )
);
/

CREATE SEQUENCE reservation_id_sequence MINVALUE 1 START WITH 1 INCREMENT BY 1;

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