/*
 问题1：SQL
 有一个订单表A，分别有order_id（订单id）、user_id（用户id）、amt（金额）三个字段，
 用sql实现以下功能：
    i. 输出每个用户top3交易金额的订单。
    ii. 输出订单总量从大到小排名在前50%的用户及其订单笔数，同时输出其交易笔数占全量订单笔数的占比。
*/




create table orders(
	order_id int not null,
	user_id int not null,
	amt int not null
);

insert into orders values
(1,1,100),
(2,1,50),
(3,1,70),
(4,1,20),
(5,2,10),
(6,2,12),
(7,2,14),
(8,3,10),
(9,3,20),
(10,3,30),
(11,3,40),
(12,3,80),
(13,4,80),
(14,4,100),
(15,4,120),
(16,4,10),
(17,5,300),
(18,5,400),
(19,5,20),
(20,5,100);


select order_id, user_id, amt
from(
  select order_id, user_id, amt, 
  	dense_rank() over(partition by user_id order by amt desc) as rank_amt
  from orders
) as t1
where rank_amt <= 3;

--mysql不支持top
select top 50 percent user_id, cnt, cnt*1.0/total_cnt
from(
	select *,sum(cnt) over() as total_cnt
	from(
	  select user_id, count(distinct order_id) as cnt
	  from orders
	  group by user_id
	) as a
) as b
order by cnt desc
;

