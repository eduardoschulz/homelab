import type {ReactNode} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';
import Projects from './projects';

function Hero() {
  const {siteConfig} = useDocusaurusContext();
  return (
    <header className={styles.hero}>
      <div className={clsx('container', styles.heroInner)}>
        <span className={styles.heroEyebrow}>homelab &mdash; infrastructure</span>
        <Heading as="h1" className={styles.heroTitle}>
          {siteConfig.title}
        </Heading>
        <p className={styles.heroSubtitle}>
          A documented journey through building and managing a private cloud,
          hypervisor cluster, and network-attached storage &mdash; all from scratch.
        </p>
        <div className={styles.heroActions}>
          <Link className="button button--primary button--lg" to="/docs">
            Browse the Wiki
          </Link>
          <Link
            className="button button--outline button--lg"
            href="https://github.com/eduardoschulz/homelab"
            target="_blank">
            GitHub
          </Link>
        </div>
      </div>
    </header>
  );
}

function About() {
  return (
    <section className={styles.about}>
      <div className="container">
        <div className={styles.aboutInner}>
          <div className={styles.aboutText}>
            <Heading as="h2" className={styles.sectionTitle}>
              About
            </Heading>
            <p className={styles.aboutDesc}>
              Hi, I&apos;m Eduardo. I build and document infrastructure in my
              homelab &mdash; a sandbox where I experiment with cloud platforms,
              virtualization, and automation. This wiki is both a personal
              reference and a way to share what I&apos;ve learned.
            </p>
            <div className={styles.aboutLinks}>
              <Link
                className="button button--outline button--sm"
                href="https://github.com/eduardoschulz"
                target="_blank">
                GitHub
              </Link>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.title}
      description="Homelab — infrastructure docs for OpenStack, Proxmox, TrueNAS, and more">
      <Hero />
      <main>
        <Projects />
        <About />
      </main>
    </Layout>
  );
}
