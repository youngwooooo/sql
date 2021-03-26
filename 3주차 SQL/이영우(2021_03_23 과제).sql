SELECT product.*, NVL(cycle.day, 0), NVL(cycle.cnt, 0), NVL(customer.cnm, 0)
FROM cycle RIGHT OUTER JOIN product ON(product.pid = cycle.pid AND cid = 1)
           LEFT OUTER JOIN customer ON(cycle.cid = customer.cid);