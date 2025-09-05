/* SPDX-License-Identifier: GPL-2.0 */
/* Copyright (c) 2025 The Inspektor Gadget authors */

#include <vmlinux.h>

#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

#include <gadget/macros.h>
#include <gadget/types.h>
#include <gadget/filter.h>

struct key_t {
  gadget_comm comm[TASK_COMM_LEN];
  gadget_mntns_id mntns_id;
};

struct value_t {
  __u64 packets;
};

struct {
  __uint(type, BPF_MAP_TYPE_HASH);
  __uint(max_entries, 1024);
  __type(key, struct key_t);
  __type(value, struct value_t);
} stats SEC(".maps");

GADGET_MAPITER(packetcounter, stats);

SEC("kprobe/udp_sendmsg")
int BPF_KPROBE(probe_udp_sendmsg, struct sock *sk) {
  struct key_t key = {};
  struct value_t *value;

  /* Filter by container using gadget helpers */
    if (gadget_should_discard_data_current())
      return 0;
    key.mntns_id = gadget_get_current_mntns_id();

  /* Get the current process name */
  bpf_get_current_comm(&key.comm, sizeof(key.comm));

  /* Lookup or initialize value */
  value = bpf_map_lookup_elem(&stats, &key);
  if (!value) {
    struct value_t zero = {};
    bpf_map_update_elem(&stats, &key, &zero, BPF_NOEXIST);
    value = bpf_map_lookup_elem(&stats, &key);
    if (!value) {
      return 0; // Failed to create entry
    }
  }

  /* Increment the packet count */
  __sync_fetch_and_add(&value->packets, 1);

  return 0;
}

char LICENSE[] SEC("license") = "GPL";