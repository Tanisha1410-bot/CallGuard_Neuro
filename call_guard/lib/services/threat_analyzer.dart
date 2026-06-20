class AnalysisResult {
  final int threatScore;
  final String status;
  final List<String> redFlags;

  AnalysisResult({
    required this.threatScore,
    required this.status,
    required this.redFlags,
  });
}

class ThreatAnalyzer {
  static const Map<String, String> _highRisk = {
    "OTP": "Requested One-Time Password (OTP) - clear financial fraud indicator.",
    "one time password": "Requested One-Time Password - clear financial fraud indicator.",
    "CVV": "Asked for CVV number of credit/debit card.",
    "card number": "Attempted to collect sensitive card details.",
    "UPI pin": "Solicited UPI PIN - highly dangerous request.",
    "account blocked": "Used 'Account Blocked' scare tactic to induce panic.",
    "account suspended": "Claimed account suspension to force immediate action.",
    "KYC expired": "Fake KYC expiration claim common in banking scams.",
    "verify immediately": "Demanded immediate verification to bypass critical thinking.",
    "act now": "Used high-pressure urgency language.",
    "legal action": "Threatened legal action to intimidate.",
    "arrest warrant": "False claim of arrest warrant - severe intimidation tactic.",
    "police case": "Threatened police involvement to enforce compliance.",
  };

  static const Map<String, String> _mediumRisk = {
    "bank official": "Impersonating a bank official to gain trust.",
    "RBI": "Claimed affiliation with the Reserve Bank of India.",
    "income tax department": "Impersonating income tax authorities.",
    "customs department": "False claim of customs hold on a package.",
    "your prize": "Promised a fake prize or reward.",
    "lottery": "Mentioned a lottery win - classic scam bait.",
    "refund process": "Offered a fake refund to obtain bank details.",
    "share your screen": "Requested screen sharing - likely attempt for remote theft.",
    "install this app": "Asked to install unknown software.",
    "remote access": "Attempted to gain remote control of the device.",
    "anydesk": "Specifically mentioned AnyDesk for remote access.",
    "teamviewer": "Specifically mentioned TeamViewer for remote access.",
  };

  static const Map<String, String> _lowRisk = {
    "don't tell anyone": "Encouraged secrecy to prevent help from others.",
    "keep this confidential": "Requested confidentiality to isolate the victim.",
    "urgent": "Mentioned urgency multiple times.",
    "immediately": "Pressed for immediate action.",
    "within 24 hours": "Set a short deadline to create pressure.",
    "your number is selected": "Claimed 'selection' common in phishing lures.",
  };

  static AnalysisResult analyze(String transcript) {
    int score = 0;
    List<String> flags = [];
    final text = transcript.toLowerCase();

    // Check High Risk Keywords (25 pts each)
    _highRisk.forEach((key, description) {
      if (text.contains(key.toLowerCase())) {
        score += 25;
        flags.add(description);
      }
    });

    // Check Medium Risk Keywords (15 pts each)
    _mediumRisk.forEach((key, description) {
      if (text.contains(key.toLowerCase())) {
        score += 15;
        flags.add(description);
      }
    });

    // Check Low Risk Keywords (10 pts each)
    _lowRisk.forEach((key, description) {
      if (text.contains(key.toLowerCase())) {
        score += 10;
        flags.add(description);
      }
    });

    // Cap score at 100
    if (score > 100) score = 100;

    String status;
    if (score <= 30) {
      status = "Safe";
    } else if (score <= 65) {
      status = "Suspicious";
    } else {
      status = "Scam";
    }

    return AnalysisResult(
      threatScore: score,
      status: status,
      redFlags: flags,
    );
  }
}
