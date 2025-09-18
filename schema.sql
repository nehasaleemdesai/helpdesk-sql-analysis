CREATE TABLE customers(
	customer_id INT PRIMARY KEY,
	name VARCHAR(50),
	region VARCHAR(50)
);

CREATE TABLE agents(
	agent_id INT PRIMARY KEY,
	agent_name VARCHAR(50),
	team VARCHAR(50)
);

CREATE TABLE tickets(
	ticket_id INT PRIMARY KEY,
	customer_id INT REFERENCES customers(customer_id),
	issue_category VARCHAR(50),
	status VARCHAR(20),
	priority VARCHAR(20),
	created_at DATE,
	resolved_at DATE,
	agent_id INT REFERENCES agents(agent_id)
);