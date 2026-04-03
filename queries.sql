-- =========================================
-- Project: Support Data Reconciliation & Analysis
-- =========================================

-- 1. Identify Data Discrepancies Across Systems
SELECT 
    p.store_id,
    p.business_date,
    p.total_sales AS pos_sales,
    r.total_sales AS reported_sales,
    (p.total_sales - r.total_sales) AS variance
FROM pos_sales p
JOIN reporting_sales r
    ON p.store_id = r.store_id
    AND p.business_date = r.business_date
WHERE ABS(p.total_sales - r.total_sales) > 10
ORDER BY variance DESC;


-- 2. Ticket Resolution & Escalation Analysis
SELECT 
    issue_type,
    COUNT(ticket_id) AS total_tickets,
    AVG(EXTRACT(EPOCH FROM (resolved_at - created_at)) / 3600) AS avg_resolution_hours,
    COUNT(CASE WHEN status = 'Escalated' THEN 1 END) AS escalations
FROM support_tickets
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY issue_type
ORDER BY total_tickets DESC;


-- 3. Root Cause Pattern Detection
SELECT 
    store_id,
    issue_type,
    COUNT(ticket_id) AS issue_count
FROM support_tickets
GROUP BY store_id, issue_type
HAVING COUNT(ticket_id) > 5
ORDER BY issue_count DESC;
