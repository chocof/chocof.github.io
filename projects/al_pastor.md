---
layout: post
title: 'Al Pastor: NIDS Dataset Generator'
---

#### Introduction
Intrusion detection systems utilize two ways to identify intrusions: misuse detection 
and anomaly detection. Misuse detection identifies anomalous states (for example, 
malicious packets) and attempts to locate them within the data set. Traditional 
Intrusion Detection Systems do this by examining the database of prior attacks and 
comparing them to the packets coming on the network (i.e., the headers and contents of 
packets on the network).


Detecting network abnormalities is a different story. In this case, the system must 
recog- nize the pattern in the data, classify a condition as ’normal,’ and then treat 
any deviation from that definition as a possible threat. This cannot be accomplished 
using conventional Intrusion Detection Systems, as previously stated, their skill is 
matched by their programmer’s.


A threat is unpredictable by definition, which is what makes it a threat in the first 
place. Machine learning techniques can control and identify behavioral problems, which 
is why there is a growing trend of employing Artificial Intelligence (AI) software in 
conjunction with IDS.


The most frequently encountered issue in machine learning research is the collection and 
structuring of data. As machine learning-based intrusion detection systems are a 
relatively new technology, it’s logical that not as much work has been done on 
developing datasets to "train" our algorithms. The majority of dataset generating 
implementations employ Packet Flow data (comparable to Cisco’s NetFlow data) and utilize 
metrics such as packet delivery rate, connection counts, and so on to identify network 
hazards. While this is an effective method for detecting the most damaging sorts of 
threats (e.g., brute force assaults), it is ineffective at detecting more complicated 
threats in which just a few fields of packets are modified to carry out the attack (for 
example the Ping of Death attack). Certain implementations augment their data with 
protocol header fields such as the TCP FLAG. However, the header fields included in 
those solutions were inserted because of previous knowledge indicating that an attacker 
may utilize this flag to launch an assault (e.g. SYN Flood). As a result, if a new 
zero-day assault exploits a vulnerability in another field (for example, TCP Options), 
the Intrusion Detection System will be unable to detect it.


The Al Pastor project’s goal is to create datasets from local networks, analyze network 
traffic, and detect risks using Neural Networks. The system generates two kinds of 
datasets: traditional Netflow data and protocol-specific data. We employ a rule-based 
intrusion detection system to assign a value (1-4) to suspicious packets depending on 
their riskiness. We next train various Neural Network models, that we refer to as 
Experts, to classify incoming packets (and packet flows) based on Snorts’ classification.


#### Introducting Al Pastor

As it was previously mentioned, existing datasets contain very little protocol-specific 
information, and the information included is restricted to protocol headers known to be 
the source of prior attacks (for example TCP, ICMP flags, number of SYN Packets, etc). 
On the other hand, while Packet Flow data is particularly effective in tracing a wide 
variety of attacks, it will have difficulties with attack vectors that do not modify the 
pace at which data is transmitted but instead rely on changes to the packet headers (for 
example FREAK, Heartbleed, Downgrade attacks). Such zero-day attacks will be extremely 
difficult to detect if their fundamental causes are not being monitored in the dataset 
(for example, a change in a TLS Record or an incorrect bit on the DNS query Type).


This is how Al Pastor came to be. By using packet header data, our first goal was to 
construct machine learning models capable of detecting attacks in protocols other like 
TCP, UDP and IP. Our experts were developed using Neural Network approaches. However, 
when developing Al Pastor, it became clear how time-consuming locating the appropriate 
dataset and testing unique examples may be. Additionally, by observing how several 
datasets supplied distinct properties, we determined that some form of dataset adaptor 
would be really beneficial. Given that the majority of publicly accessible datasets 
contain their original capture files (pcap), we had the following thought: What if we 
could construct our own datasets by parsing pcap files? In this manner, we may generate 
datasets by capturing packets in our local network traffic and also by converting 
different public datasets into a single format, allowing us to exploit their collective 
expertise without the need to change our expert models.


#### Architecture

Consequently, we built a software for producing NIDS datasets from pcap files. Al Pastor supports the creation of two types of datasets:
* Protocol Header Datasets: Those dataset contain packet protocol specific information a
nd they differ per protocol stack (for example ETH/IPv4/TCP Dataset, ETH/IPv4/UDP 
Dataset, ETH/IPv4/QUICC, etc.)
* Packet-Flow Data: [Netflow-like](https://en.wikipedia.org/wiki/NetFlow) data.


A label is then assigned to each entry in the dataset based on whether the respective 
packets contained threats or raised an Alert. In order to diagnose threats we are using 
a Signature/Rule-based IDS called [Snort](https://www.snort.org/). The overall Dataset 
Creation Process is displayed bellow: a pcap file which contains TCP, UDP and ARP 
packets is parsed and  multiple datasets are created from it. Afterwards Snort assigns a 
label to each entry of every dataset.

{% include image.html
text="Dataset Creation." image="projects/al_pastor/workflow.png" %}

The datasets are then utilized to train the NN Experts. Each form of NN Expert enables 
us to investigate various types of threats:
* *Protocol Header Experts*: These specialists are capable of tracing the same threats 
that the signature-based IDS can, as well as their variations. Additionally, this IDS 
functions as an Anomaly-based IDS, defining a typical packet header state and raising 
warnings when strange packets are identified.
* *Packet-Flow Expert*: Is able to locate weird patterns in rate of data transmissions. 
Therefore it is mostly able to distinguish Interruption attacks, similarly to IDSs 
trained with the KDD and the NSL-KDD Datasets

{% include image.html
text="Expert Training." image="projects/al_pastor/expert_training.png" %}

You may download the thesis paper (that is supplied  <a href="{{ site.github.url }}/assets/pdf/al_pastor.pdf" download>here</a>) for a more in-depth look at the project, its design, and its findings.