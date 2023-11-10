-- Add migration script here
create table user (
    id integer not null primary key,
    username text not null unique,
    password text not null
);

create table contact (
    id integer not null primary key,
    first_name text not null,
    last_name text not null,
    email text not null unique,
    phone text not null unique,
    foreign key (id) references user (id)
);

create table product (
    id integer not null primary key,
    name text not null,
    price real not null
);
