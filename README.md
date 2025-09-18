# 📦 Repo Mirror & Release Manager

A Bash script powered by **`mpgrm`** for automating **release uploads**, **repository mirroring**, and **tag synchronization**.
 Designed for **GitHub Actions** or other CI/CD pipelines.

## 🚀 Features

- 🔍 Prints `mpgrm` version (for verification)
- 📤 Upload release assets to the source repository
- 🔄 Mirror source repository to a target repository
- 🔖 Sync tags between repositories
- ⚡ Lightweight, built for GitHub Actions

⚙️ Inputs

| Input             | Required | Description                                                  |
| ----------------- | -------- | ------------------------------------------------------------ |
| `repo`            | false    | Source repository URL (default: `https://github.com/${GITHUB_REPOSITORY}.git`) |
| `username`        | false    | Source repository username (default: `${GITHUB_ACTOR}`)      |
| `password`        | false    | Source repository password (optional)                        |
| `token`           | false    | Source repository token (**preferred** over password)        |
| `target_repo`     | false    | Target repository URL                                        |
| `target_username` | false    | Target repository username                                   |
| `target_password` | false    | Target repository password (optional)                        |
| `target_token`    | false    | Target repository token (**preferred** over password)        |
| `tags`            | false    | Tags to upload/sync (comma-separated or single tag, e.g. `${{ github.ref_name }}`) |
| `files`           | false    | Files to upload as release assets (comma-separated paths, e.g. `dist/*.tar.gz`) |

## 🔑 Authentication Rules

- For **source repo**: `token` takes precedence over `password`
- For **target repo**: `target_token` takes precedence over `target_password`

## 📜 Usage

### Example: Upload Release Assets

```yaml
- name: Repo Release
  uses: chihqiang/repo-action@main
  with:
    tags: ${{ github.ref_name }}
    token: ${{ secrets.GH_TOKEN }}
    files: dist/*.tar.gz,dist/*.zip,dist/*.md5,dist/*.sha256
```

### 🔄 Example: Mirror GitHub →Gitee (with tag release)

```yaml
- name: Repo Sync
  uses: chihqiang/repo-action@main
  with:
    target_repo: https://gitee.com/owner/repo.git
    target_username: youruser
    target_password: ${{ secrets.GITEE_PASSWORD }}
    target_token: ${{ secrets.GITEE_TOKEN }}
    tags: ${{ github.ref_name }}
```

✅ In this setup:

- The workflow triggers **only on tag pushes**
- Mirrors the GitHub repo into **Gitea**，**Gitee**，**CNB**
- Syncs the pushed **tag release** into the target repo

## 📝 Workflow Explanation

1. **Check `mpgrm` version** → ensures the tool is installed
2. **Print environment variables** (debug mode, optional)
3. **Upload release assets** → if `repo + (token or password) + tags + files` are present
4. **Push repository to target** → if `target_repo + target_username + (target_token or target_password)` are present
5. **Sync tags** → if `tags` exist and authentication is available
