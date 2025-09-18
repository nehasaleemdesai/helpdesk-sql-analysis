// Show all open tickets
SELECT * FROM tickets
WHERE status = 'open';

// Count how many tickets are in each issue category.
SELECT issue_category, SUM(ticket_id)
FROM tickets
GROUP BY issue_category;

// Find the names of all customers in the South region.
SELECT * FROM customers
WHERE region = 'South';

// List all agents from the L1 Support team.
SELECT * FROM agents
WHERE team = 'L1 Support';

// Find tickets that were created in September 2024.
SELECT * FROM tickets
WHERE created_at >= '2024-09-01' AND created_at <= '2024-09-30';

// Show each customer’s name along with how many tickets they have opened.
SELECT name, COUNT(tickets.ticket_id)
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY name;

// List tickets with their assigned agent’s name.
SELECT *, tickets.ticket_id
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id;

// Find the average resolution time (in days) for each issue category.
SELECT issue_category, ROUND(AVG(((EXTRACT(DAY FROM resolved_at)) - (EXTRACT(DAY FROM created_at)))), 2)
FROM tickets
GROUP BY issue_category;

// Show all agents who have resolved more than 10 tickets.
SELECT agent_name, COUNT(tickets.ticket_id)
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
GROUP BY agent_name
HAVING COUNT(tickets.ticket_id) >10;

// Find the region that created the most tickets overall.
SELECT region, COUNT(tickets.ticket_id) AS most_tickets
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY region
ORDER BY COUNT(tickets.ticket_id) DESC;

// Rank agents by number of tickets resolved (highest to lowest).
SELECT agent_name, COUNT(tickets.ticket_id)
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
GROUP BY agent_name
ORDER BY COUNT(tickets.ticket_id) DESC;

// Find customers who raised more than 3 high-priority tickets.
SELECT name, COUNT(tickets.priority)
FROM customers
INNER JOIN tickets
ON customers.customer_id = tickets.customer_id
GROUP BY name
HAVING COUNT(tickets.priority) > 3;

// Show the average resolution time by agent team.
SELECT team, ROUND(AVG(((EXTRACT(DAY FROM tickets.resolved_at)) - (EXTRACT(DAY FROM tickets.created_at)))), 2)
FROM agents
INNER JOIN tickets
ON agents.agent_id = tickets.agent_id
GROUP BY team;

// Identify the issue category with the longest average resolution time.
SELECT issue_category, ROUND(AVG(((EXTRACT(DAY FROM tickets.resolved_at)) - (EXTRACT(DAY FROM tickets.created_at)))), 2)
FROM tickets
GROUP BY issue_category
ORDER BY issue_category DESC;

