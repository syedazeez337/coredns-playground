# 🚀 CoreDNS Playground

Welcome to your interactive CoreDNS lab!
In the next few steps, you'll build CoreDNS from source, serve DNS zones, and simulate how Kubernetes resolves internal service names.

---

### ✅ Step 1: Build CoreDNS

From the terminal:

```bash
cd coredns
make
```

This compiles CoreDNS from source using Go. You should see a new binary called `./coredns`.

---

### ✅ Step 2: Run CoreDNS

Now run CoreDNS on a non-privileged port (1053):

```bash
./coredns -dns.port=1053
```

Expected output:

```
.:1053
hello.dev.:1053
svc.cluster.local.:1053
CoreDNS-...
```

If you see “permission denied” on port 53, double-check that you're using `-dns.port=1053`.

---

### ✅ Step 3: Query DNS with `dig`

Open a **new terminal** and try some DNS lookups:

```bash
dig @127.0.0.1 -p 1053 hello.dev
dig @127.0.0.1 -p 1053 api.default.svc.cluster.local
dig @127.0.0.1 -p 1053 web.default.svc.cluster.local
```

Expected results:

- `hello.dev. A 1.2.3.4`
- `api.default.svc.cluster.local A 10.96.0.1`
- `web.default.svc.cluster.local A 10.96.0.2`

---

### 🧠 What's Happening?

Your Corefile defines three DNS zones:

```txt
hello.dev {
    file db.hello.dev
    log
    errors
}

svc.cluster.local {
    file db.svc.cluster.local
    log
    errors
}

. {
    forward . 8.8.8.8
    log
    errors
}
```

- `hello.dev` is served using a static zone file (like for internal testing).
- `svc.cluster.local` simulates what Kubernetes does for services.
- `.` forwards all other queries to Google DNS.

---

### 🧠 Bonus DNS Concepts

| Record Type | Purpose |
|-------------|---------|
| `A`         | Maps domain name to IPv4 |
| `NS`        | Declares authoritative nameserver |
| `SOA`       | Declares zone ownership + refresh policy |
| `$ORIGIN`   | Sets the default domain root for zone file |

---

### 🧠 Real-World Relevance

- CoreDNS is the default DNS server in Kubernetes clusters.
- This playground mimics its behavior when resolving services like:
  `api.default.svc.cluster.local`

Understanding this is **critical** if you're doing:
- Kubernetes debugging
- Service discovery
- Internal networking in clusters

---

### 📚 Learn More

- 🔌 [CoreDNS Plugin Docs](https://coredns.io/plugins/)
- 🧪 [CoreDNS GitHub](https://github.com/coredns/coredns)
- ☸️ [Kubernetes DNS Explained](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

---

### ✅ What’s Next?

- Try editing the Corefile to change IPs or add new zones.
- Try breaking things (e.g., remove an SOA record) and see how CoreDNS responds.
- Use this setup to prototype your own plugins later!

Happy resolving! 🧠🧩