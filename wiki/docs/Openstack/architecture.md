---
sidebar_position: 4
title: OpenStack Architecture
---

# OpenStack Architecture

Overview of how OpenStack services interconnect.

## Service Topology

```mermaid
graph TD
    Horizon[Horizon Dashboard]
    Keystone[Keystone Identity]
    Nova[Nova Compute]
    Neutron[Neutron Networking]
    Glance[Glance Image]
    Cinder[Cinder Block Storage]

    Horizon --> Keystone
    Keystone --> Nova
    Keystone --> Neutron
    Keystone --> Glance
    Keystone --> Cinder
    Nova --> Glance
    Nova --> Neutron
    Nova --> Cinder
    Cinder --> Glance
```

## Core Concepts

- **Projects & Users** — Multi-tenancy via Keystone domains, projects, and roles
- **Regions & AZs** — Physical isolation and failure domains
- **Cells** — Nova scaling unit for large deployments
- **API Endpoints** — Each service exposes a REST API registered in Keystone's catalog
