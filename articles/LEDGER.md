# The Daily AI News — Articles Ledger

State for the daily article-writing run (see the task's article-anatomy spec). Never delete
a line here — future runs read this to deduplicate topics by meaning, not exact wording.

Format: `- {date} | {pillar} | {title} | {slug} | key concepts: {3-5 comma-separated concepts}`

## Already published

- 2026-07-16 | Pillar 9 — Full-Stack Agentic Engineering | Streaming Agent Output to the Browser: SSE, WebSockets, and the Reconnect Problem | streaming-agent-output-to-the-browser | key concepts: SSE vs WebSockets decision rule, Redis Streams as a durable resumable event buffer, Last-Event-ID reconnect protocol shared across runtime/API/frontend, proxy-buffering failure mode, backpressure from slow/backgrounded clients
- 2026-07-17 | Pillar 7 — Evals, Observability & Safety | OpenTelemetry for Agents: Tracing a Request Across the Whole Stack | opentelemetry-for-agents-full-stack-tracing | key concepts: W3C traceparent context propagation across browser/API/agent/DB layers, OTel GenAI semantic conventions (gen_ai.* attributes, invoke_agent/chat/execute_tool span shapes), span links vs parent-child for async queue hand-offs, tail-based sampling to catch error traces, content-capture PII/cost risk in span attributes
- 2026-07-17 | Pillar 5 — Data & Integration | Tool Design as API Design: The Contract Your Agent's Tools Can't Skip | tool-design-as-api-design | key concepts: idempotency keys minted by the harness (not the model) and reused across retries, atomic key-claiming via INSERT ON CONFLICT, retryable-vs-terminal typed error taxonomy, tool schema versioning to avoid silent contract drift, idempotent approval-surface UI as a separate retry boundary from the tool call itself
