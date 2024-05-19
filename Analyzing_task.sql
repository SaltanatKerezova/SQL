-- Quantity of emails that have 'spam' in the detection_us column in engine_us table:
SELECT COUNT (detection_us)
FROM engine_us   
WHERE detection_us = 'spam'


-- Sender that sent the most emails and the quantity of emails (email is identified by a unique email_id)
SELECT sender, COUNT(*)
FROM email_senders
GROUP BY sender
HAVING COUNT(email_id) > 1          
ORDER BY COUNT(*) DESC
LIMIT 1 ;


/* Quantiy of emails that are in both tables engine_us and engine_cz
 (any value 'spam' or 'phishing' is enough for a detection) */
SELECT COUNT(*) AS num_emails_detected_by_both
FROM engine_cz
INNER JOIN engine_us ON engine_cz.email_id = engine_us.email_id
WHERE engine_cz.detection_cz IN ('spam', 'phishing')
AND engine_us.detection_us IN ('spam', 'phishing');


-- Senders in the email_senders table that are NOT present in engine_cz table.
SELECT distinct(email_senders.sender),
FROM email_senders
LEFT JOIN engine_cz
    ON email_senders.email_id = engine_cz.email_id
WHERE email_senders.email_id NOT IN (SELECT email_id FROM engine_cz)


-- Senders that have the mostquantity of emails in at least one of the tables.
(SELECT DISTINCT(email_senders.sender), COUNT(engine_us.email_id) as count
FROM email_senders
LEFT JOIN engine_us ON email_senders.email_id = engine_us.email_id
GROUP BY email_senders.sender
ORDER BY count DESC
LIMIT 3)
UNION
(SELECT DISTINCT(email_senders.sender), COUNT(engine_cz.email_id) as count
FROM email_senders
LEFT JOIN engine_cz ON email_senders.email_id = engine_cz.email_id
GROUP BY email_senders.sender
ORDER BY count DESC
LIMIT 3)
ORDER BY count DESC;

