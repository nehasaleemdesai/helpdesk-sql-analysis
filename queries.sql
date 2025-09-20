// Show all open tickets
SELECT * FROM tickets
WHERE status = 'open';

// Count how many tickets are in each issue category.
SELECT issue_category, COUNT(ticket_id)
FROM tickets
GROUP BY issue_category;

// Find the names of all customers in the South region.
SELECT name FROM customers
WHERE region = 'South';

// List all agents from the L1 Support team.
SELECT agent_id, agent_name FROM agents
WHERE team = 'L1 Support';

// Find tickets that were created in September 2024.
SELECT * FROM tickets AS sept_tickets
WHERE created_at BETWEEN '2024-09-01' AND '2024-09-30';

// Show each customer’s name along with how many tickets they have opened.
SELECT customers.customer_id, name, COUNT(tickets.ticket_id) AS ticket_count
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY customers.customer_id, name
ORDER BY ticket_count DESC;

// List tickets with their assigned agent’s name.
SELECT agents.agent_name, tickets.ticket_id
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id;

// Find the average resolution time (in days) for each issue category.
SELECT issue_category, ROUND(AVG(resolved_at - created_at), 2) AS avg_days
FROM tickets
GROUP BY issue_category;

// Show all agents who have resolved more than 10 tickets.
SELECT agent_name, COUNT(tickets.ticket_id) AS resolved_count
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
WHERE tickets.status = 'closed'
GROUP BY agent_name
HAVING COUNT(tickets.ticket_id) >10
ORDER BY resolved_count DESC;

// Find the region that created the most tickets overall.
SELECT region, COUNT(tickets.ticket_id) AS most_tickets
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY region
ORDER BY most_tickets DESC;

// Rank agents by number of tickets resolved (highest to lowest).
SELECT agent_name, COUNT(tickets.ticket_id) AS resolved_count
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
WHERE tickets.status = 'closed'
GROUP BY agent_name
ORDER BY resolved_count DESC;

// another way
SELECT a.agent_name,
       COUNT(t.ticket_id) AS resolved_count,
       RANK() OVER (ORDER BY COUNT(t.ticket_id) DESC) AS rnk
FROM agents a
JOIN tickets t ON a.agent_id = t.agent_id
WHERE t.status = 'closed'
GROUP BY a.agent_name;

// Find customers who raised more than 3 high-priority tickets.
SELECT customers.customer_id, name, COUNT(*) AS high_prty_count
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
WHERE tickets.priority = 'high'
GROUP BY customers.customer_id, name
HAVING COUNT(*) > 3
ORDER BY high_prty_count DESC;

// Show the average resolution time by agent team.
SELECT team, ROUND(AVG(resolved_at - created_at), 2) AS avg_days
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
WHERE tickets.status = 'closed' AND tickets.resolved_at IS NOT NULL
GROUP BY team
ORDER BY avg_days DESC;

// Identify the issue category with the longest average resolution time.
SELECT issue_category, ROUND(AVG(resolved_at - created_at), 2) AS avg_days
FROM tickets
WHERE status = 'closed'
GROUP BY issue_category
ORDER BY avg_days DESC;

// Find tickets that took longer than the overall average resolution time to resolve.
SELECT *
FROM tickets
WHERE status = 'closed' AND (resolved_at - created_at) >
    (SELECT AVG(resolved_at - created_at) FROM tickets WHERE status = 'closed');

// Monthly trend: number of tickets opened per month in 2024.
SELECT EXTRACT(MONTH FROM created_at) AS month,
COUNT(created_at)
FROM tickets
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'
GROUP BY month
ORDER BY month;

// anothery way
    SELECT DATE_TRUNC('month', created_at) AS month, COUNT(*) AS tickets
FROM tickets
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;

// Compare average resolution time between L1 and L2 support teams.
SELECT team, ROUND(AVG(resolved_at - created_at), 2) AS resolve_time
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
WHERE tickets.status = 'closed' AND team IN ('L1 Support', 'L2 Support')
GROUP BY team;

// Find the percentage of tickets resolved within 48 hours.
SELECT ROUND (100.0*( SELECT COUNT(*) FROM tickets
WHERE status = 'closed' AND (resolved_at - created_at) <= 2) 
/
(
	SELECT COUNT(*) FROM tickets
	WHERE status = 'closed'
), 2) AS resolv_within_48;

// another way (efficient)
SELECT ROUND(100.0 *
  COUNT(*) FILTER (WHERE (resolved_at - created_at) <= 2) / COUNT(*), 2)
                /* FILTER (WHERE …) → applies the aggregate only to rows that satisfy the condition.*/
FROM tickets
WHERE status = 'closed';


// Show the top 5 customers with the most closed tickets.
SELECT customers.customer_id, name, COUNT(*) AS max_closed_tts
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
WHERE tickets.status = 'closed'
GROUP BY customers.customer_id, name
ORDER BY max_closed_tts DESC
LIMIT 5;

// For each region, show the most common issue category.
SELECT DISTINCT ON (region)  /* DISTINCT ON -> gives only the first row per region */ 
region, issue_category, COUNT(*) AS count
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY region, issue_category
ORDER BY region, count DESC, issue_category;