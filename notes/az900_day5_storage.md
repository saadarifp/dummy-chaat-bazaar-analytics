# AZ-900 Day 5: Azure Storage

Storage Account: the top level container that holds blobs, files, queues and tables, with settings for redundancy and access tiers.
Blob Storage: object storage for unstructured files such as images, CSVs, PDFs, backups. The default choice for most files an application reads and writes.
Azure Files: fully managed file shares mounted like a network drive over SMB. Use when people or legacy apps expect a shared drive.
Queue Storage: holds messages so systems can pass work to each other asynchronously.
Table Storage: simple NoSQL key value storage for structured, non relational data.
Managed Disks: block storage attached to VMs, used as OS and data disks.

Access tiers: Hot for frequent access, Cool for infrequent (30+ days), Cold for rare (90+ days), Archive for almost never (180+ days, hours to retrieve). Storage gets cheaper and retrieval gets slower or costlier down the tiers.

Redundancy:
LRS: three copies in one datacenter. Cheapest. Survives disk failure, not a datacenter outage.
ZRS: copies across three availability zones in the region. Survives a full datacenter failure.
GRS: LRS in the primary region plus copies in the paired region hundreds of km away. Survives regional disaster.
GZRS: ZRS locally plus geo copies. Maximum protection.

## Practice answers
1. Restaurant food photographs: Blob Storage, Hot tier. Unstructured images served frequently to the website and menus.
2. Daily sales CSV files: Blob Storage. Files written once daily and read by analytics, no shared drive semantics needed.
3. Invoice PDFs: Blob Storage, Cool tier after the first month. Rarely opened after processing.
4. Files shared between accounts staff: Azure Files. Staff need a mounted shared drive that behaves like a normal folder.
5. VM operating system disk: Managed Disk. VMs boot from block storage, not object storage.
6. Old invoices retained for years: Blob Storage, Archive tier. Legal retention with almost zero reads justifies the cheapest tier despite slow retrieval.
7. Business critical backup with geographic protection: Blob Storage with GRS or GZRS. A Dubai wide event must not destroy the only copies.

LRS vs ZRS vs GRS in my own words: LRS protects against a broken disk inside one building. ZRS protects against the whole building going down by spreading copies across separate datacenters in the region. GRS protects against the whole region going down by keeping copies in a second distant region. Cost and protection both rise in that order.
