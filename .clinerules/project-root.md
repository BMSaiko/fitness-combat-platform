## Brief overview
Project root path constraint for the **fitness-combat-platform** repository. These rules ensure all operations stay within the project boundaries.

## Project root constraint
- **Root path:** `C:\Users\bruno\Documents\fitness-combat-platform`
- **NEVER** access, modify, or reference files outside this directory
- **NEVER** use paths like `C:\Users\bruno\Documents\lei25-26\sem4\repo` or any other external directories
- All file operations (read, write, create, delete) must use relative paths from the project root
- When executing commands, always `cd` to the project root first

## Git operations
- Always verify the remote URL is `https://github.com/BMSaiko/fitness-combat-platform.git`
- Never push to or pull from `Departamento-de-Engenharia-Informatica/sem4pi2526-sem4pi2526_2de4`
- Branch naming convention: `f{epic}-{number}-{short-description}` (e.g., `f1-005-docker-dev`)

## GitHub CLI and MCP usage
- Use `gh` commands and the `fitness-combat-platform` MCP server ONLY for the BMSaiko/fitness-combat-platform repository
- **NEVER** use the MCP GitHub tools for any other repository
- The MCP server is configured specifically for `BMSaiko/fitness-combat-platform` - do not change this
- Always include issue references in commit messages (e.g., "Closes #9")
- Prohibited: using MCP tools to access, modify, or query any repository other than BMSaiko/fitness-combat-platform

## Development workflow
- **ALWAYS use subagents** for parallel task execution when possible
- Use subagents for: reading/analyzing multiple files, implementing features across modules, researching code patterns, parallel exploration
- Optimize task completion by running independent operations in parallel

## Communication style
- Be direct and technical
- Use Portuguese (PT-PT) when communicating with the user
- Present results concisely
