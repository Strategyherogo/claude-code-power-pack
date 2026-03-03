# Skill: api-docs
Generate API documentation from code.

## Auto-Trigger
**When:** "api docs", "document api", "api documentation", "endpoint docs", "swagger"

## Documentation Formats

### OpenAPI/Swagger
```yaml
openapi: 3.0.0
info:
  title: [API Name]
  version: 1.0.0
  description: [Brief description]

servers:
  - url: https://api.example.com/v1
    description: Production

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 10
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
        email:
          type: string
```

### Markdown API Docs
```markdown
# API Reference

## Base URL
`https://api.example.com/v1`

## Authentication
All requests require Bearer token:
```
Authorization: Bearer <token>
```

---

## Endpoints

### Users

#### List Users
`GET /users`

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| limit | int | No | Max results (default: 10) |
| offset | int | No | Pagination offset |

**Response:**
```json
{
  "users": [
    {
      "id": "usr_123",
      "email": "user@example.com"
    }
  ],
  "total": 100
}
```

**Status Codes:**
| Code | Description |
|------|-------------|
| 200 | Success |
| 401 | Unauthorized |
| 500 | Server error |
```

## Generate from Code

### From Express/Node
```bash
# Look for route definitions
grep -r "app\.\(get\|post\|put\|delete\)" src/routes/

# Look for OpenAPI comments
grep -r "@openapi" src/
```

### From FastAPI/Python
```bash
# FastAPI auto-generates OpenAPI
# Access at /docs or /openapi.json
```

### From Comments
```javascript
/**
 * @api {get} /users List Users
 * @apiName GetUsers
 * @apiGroup Users
 * @apiParam {Number} [limit=10] Results per page
 * @apiSuccess {Object[]} users List of users
 */
```

## Documentation Template

### Endpoint Documentation
```markdown
## [Method] [Path]

[One-line description]

### Request

**Headers:**
| Header | Value | Required |
|--------|-------|----------|
| Authorization | Bearer {token} | Yes |
| Content-Type | application/json | Yes |

**Path Parameters:**
| Name | Type | Description |
|------|------|-------------|
| id | string | Resource ID |

**Query Parameters:**
| Name | Type | Default | Description |
|------|------|---------|-------------|
| limit | int | 10 | Max results |

**Body:**
```json
{
  "field": "value"
}
```

### Response

**Success (200):**
```json
{
  "data": {}
}
```

**Error (400):**
```json
{
  "error": "message"
}
```

### Example
```bash
curl -X GET "https://api.example.com/v1/users" \
  -H "Authorization: Bearer <YOUR_TOKEN>"
```
```

## Output Formats
- `docs/api.md` - Markdown reference
- `docs/openapi.yaml` - OpenAPI spec
- `docs/postman.json` - Postman collection

## Tools Integration
- **Swagger UI:** Interactive docs
- **Redoc:** Beautiful static docs
- **Postman:** Import for testing

---
Last updated: 2026-01-29
