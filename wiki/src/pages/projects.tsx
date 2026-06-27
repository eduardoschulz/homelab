import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import Heading from '@theme/Heading';

import styles from './index.module.css';

export type Project = {
  title: string;
  label: string;
  description: string;
  tech: string[];
  link: string;
  accent: string;
};

export const projects: Project[] = [
  {
    title: 'Kubernetes',
    label: 'Orchestration',
    description:
      'Lightweight k3s cluster running on Proxmox VMs. Covers cluster bootstrapping, Helm, ingress, persistent storage, and workload deployment patterns.',
    tech: ['k3s', 'Helm', 'MetalLB', 'Longhorn'],
    link: '/docs/Kubernetes',
    accent: '#326CE5',
  },
  {
    title: 'Observability',
    label: 'Monitoring',
    description:
      'Full-stack monitoring and logging pipeline with Grafana, Prometheus, Loki, and Alertmanager. Dashboards, alerts, and log aggregation for the entire homelab.',
    tech: ['Grafana', 'Prometheus', 'Loki', 'Tempo'],
    link: '/docs/Observability',
    accent: '#10B981',
  },
  {
    title: 'OpenStack',
    label: 'Private Cloud',
    description:
      'Full OpenStack deployment with Kolla Ansible on a single node. Covers architecture, core services, Terraform IaC, and operational guides for Nova, Neutron, Cinder, and more.',
    tech: ['Kolla Ansible', 'Terraform', 'Neutron', 'Cinder'],
    link: '/docs/Openstack/intro',
    accent: '#E54060',
  },
  {
    title: 'Proxmox',
    label: 'Hypervisor',
    description:
      'Proxmox VE setup with cloud-init VM templates and Terraform provider integration. Automated provisioning and infrastructure-as-code for virtual machines.',
    tech: ['Proxmox VE', 'Cloud-Init', 'Terraform', 'Ubuntu'],
    link: '/docs/Proxmox/cloudinit',
    accent: '#D97706',
  },
  {
    title: 'TrueNAS',
    label: 'Storage',
    description:
      'ZFS-based network storage with dataset tuning, share configuration, and performance optimization for homelab workloads.',
    tech: ['NAS', 'NFS', 'SMB', 'ZFS'],
    link: '/docs/TrueNAS',
    accent: '#1E6FA8',
  },
];

function ProjectCard({title, label, description, tech, link, accent}: Project) {
  return (
    <Link to={link} className={styles.card}>
      <div className={styles.cardBar} style={{backgroundColor: accent}} />
      <div className={styles.cardBody}>
        <span className={styles.cardLabel}>{label}</span>
        <Heading as="h3" className={styles.cardTitle}>
          {title}
        </Heading>
        <p className={styles.cardDesc}>{description}</p>
        <div className={styles.cardTags}>
          {tech.map((t) => (
            <span key={t} className={styles.cardTag}>
              {t}
            </span>
          ))}
        </div>
      </div>
    </Link>
  );
}

export default function Projects(): ReactNode {
  return (
    <section className={styles.projects}>
      <div className="container">
        <Heading as="h2" className={styles.sectionTitle}>
          Projects
        </Heading>
        <p className={styles.sectionSubtitle}>
          Each section is a self-contained guide covering setup, configuration, and operational notes.
        </p>
        <div className={styles.grid}>
          {projects.map((p) => (
            <ProjectCard key={p.title} {...p} />
          ))}
        </div>
      </div>
    </section>
  );
}
