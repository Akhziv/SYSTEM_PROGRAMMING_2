# Nightly snapshot uploads

This service will continuously verify that Forest can export snapshots. Once per
day, this service will sync to calibnet and export a new snapshot. If the
previous snapshot is more than a day old, the new snapshot is uploaded to
Dig