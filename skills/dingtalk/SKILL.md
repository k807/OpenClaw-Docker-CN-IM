---
name: dingtalk
description: 和钉钉文档打通，用于语义搜索、内容检索、文档管理。
---

# dingtalk

| # | Tool Name | CLI Call (Minimal) | Description | Parameters (JSON Schema subset) |
|---|-----------|----------------------|-------------|---------------------------------|
| 1 | `fetchExternalContentByUrl` | `mcporter call dingtalk.fetchExternalContentByUrl url="https://alidocs.dingtalk.com/i/nodes/R1zknDm0WR6XzZ4Lt2yxxvAOWBQEx5rG"` | 通过钉钉或者语雀文档链接获取文档内容，如果获取不到内容，请检查知识库是否完成授权，如果知识库未完成授权，请访问链接进行授权检测 | /**<br/>   * 通过钉钉或者语雀文档链接获取文档内容，如果获取不到内容，请检查知识库是否完成授权，如果知识库未完成授权，请访问链接进行授权检测<br/>   *<br/>   * @param url 文档链接，支持语雀域名（aliyuque.antfin.com、yuque.antfin-inc.com、yuque.antfin.com、yuque.alibaba-inc.com）和钉钉域名（alidocs.dingtalk.com）<br/>   */<br/>  function fetchExternalContentByUrl(url: string); |
| 2 | `fetchKnowledgeDirectoryByUrl` | `mcporter call dingtalk.fetchKnowledgeDirectoryByUrl url="https://alidocs.dingtalk.com/i/spaces/abcd/overview" recursive=false` | 通过钉钉或者语雀知识库链接获取知识库的目录列表，如果获取不到内容，请检查知识库是否完成授权，如果知识库未完成授权，请访问链接进行授权检测 | /**<br/>   * 通过钉钉或者语雀知识库链接获取知识库的目录列表，如果获取不到内容，请检查知识库是否完成授权，如果知识库未完成授权，请访问链接进行授权检测<br/>   *<br/>   * @param url 知识库链接，支持语雀域名（aliyuque.antfin.com、yuque.antfin-inc.com、yuque.antfin.com、yuque.alibaba-inc.com）和钉钉域名（alidocs.dingtalk.com），钉钉知识库链接示例：https://alidocs.dingtalk.com/i/spaces/xxx/overview，语雀知识库链接示例：https://aliyuque.antfin.com/team/repo<br/>   * @param parentUuid? 父节点UUID（钉钉知识库专用），用于指定从哪个节点开始获取目录。如果不指定则从根目录开始。注意：此参数仅对钉钉知识库生效，语雀知识库会忽略此参数<br/>   * @param recursive? 是否递归获取子目录（钉钉知识库专用）。true：递归获取所有子目录；false：只获取一层子目录。默认为<br/>   *                   true。注意：此参数仅对钉钉知识库生效，语雀知识库会忽略此参数<br/>   */<br/>  function fetchKnowledgeDirectoryByUrl(url: string, parentUuid?: string, recursive?: boolean); |