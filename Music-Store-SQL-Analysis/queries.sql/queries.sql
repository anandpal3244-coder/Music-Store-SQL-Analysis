use music_project;

1.We want to assign an senior employee to lead that project. Who is the senior most employee based on job title?

👉 select title,first_name , last_name,email from employee
 order by levels desc
limit 1;

2.Which county has most number of Invoices?


👉 select billing_country,count(*) as 'count' from invoice
group by billing_country
order by count desc limit 1;


3.What is value of top 3 invoices ?
👉 select * from invoice
order by total desc limit 3;

4.We would like to throw a promotional Music Festival in the city we made the most money. Which city has the best customers?
👉 select billing_city,sum(total) as total from invoice
group by billing_city
order by total desc limit 1;


5.Who is the best customer? The customer who has spent the most money will be declared the best customer. 
👉 select customer.customer_id,first_name,last_name,
SUM(total) AS Total_Spending from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id,first_name,last_name
order by Total_Spending desc limit 1;

6. Details of customers who listens  Rock music.
👉 select distinct first_name,last_name,email from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where  track_id in (
select track_id from track
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock');

7. Let's invite the artists who have written the most rock music in our dataset. 

👉 select artist.artist_id,artist.name,genre.name,count(artist.artist_id) as Num_of_Songs from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
join genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
group by artist.artist_id,artist.name,genre.name
order by Num_of_Songs desc limit 3;

8.We want to find out the most popular music Genre for each country. 
👉 with genre_sales as (
select invoice.billing_country,sum(invoice_line.quantity)as Qnty,genre.name as genre ,
rank() over(partition by invoice.billing_country order by sum(invoice_line.quantity)desc) as rnk
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
join track on invoice_line.track_id = track.track_id
join genre on track.genre_id = genre.genre_id
group by invoice.billing_country,genre.name)
SELECT billing_country,genre,Qnty FROM genre_sales
WHERE rnk = 1;

9.We want to give gifts to top customer so Determine which customer has spent the most on music for each country. 
👉 with Customer_spend as (
select 
customer.customer_id,first_name,last_name,billing_country,sum(total) as Total_Spend,
row_number() over(partition by billing_country order by SUM(total) DESC)as rn
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id,first_name,last_name,billing_country
order by billing_country , Total_Spend desc )
select billing_country,
customer_id,first_name,last_name,billing_country,Total_Spend
from Customer_spend
where rn = 1 
order by billing_country
;

