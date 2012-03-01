#include <stdio.h>
#include <stdint.h>

#include "c20msg.h"

/*
 * decode capi 2.0 info word
 */
const char *capi_info_string(uint16_t wInfo)
{
	switch (wInfo) {
	/* informative values (corresponding message was processed) */
	case 0x0001:
		return "NCPI not supported by current protocol, NCPI ignored";
	case 0x0002:
		return "Flags not supported by current protocol, flags ignored";
	case 0x0003:
		return "Alert already sent by another application";

	/* error information concerning CAPI_REGISTER */
	case 0x1001:
		return "Too many applications";
	case 0x1002:
		return "Logical block size to small, must be at least 128 Bytes";
	case 0x1003:
		return "Buffer exceeds 64 kByte";
	case 0x1004:
		return "Message buffer size too small, must be at least 1024 Bytes";
	case 0x1005:
		return "Max. number of logical connections not supported";
	case 0x1006:
		return "Reserved";
	case 0x1007:
		return "The message could not be accepted because of an internal busy condition";
	case 0x1008:
		return "OS resource error (no memory ?)";
	case 0x1009:
		return "CAPI not installed";
	case 0x100A:
		return "Controller does not support external equipment";
	case 0x100B:
		return "Controller does only support external equipment";

	/* error information concerning message exchange functions */
	case 0x1101:
		return "Illegal application number";
	case 0x1102:
		return "Illegal command or subcommand or message length less than 12 bytes";
	case 0x1103:
		return "The message could not be accepted because of a queue full condition !! The error code does not imply that CAPI cannot receive messages directed to another controller, PLCI or NCCI";
	case 0x1104:
		return "Queue is empty";
	case 0x1105:
		return "Queue overflow, a message was lost !! This indicates a configuration error. The only recovery from this error is to perform a CAPI_RELEASE";
	case 0x1106:
		return "Unknown notification parameter";
	case 0x1107:
		return "The Message could not be accepted because of an internal busy condition";
	case 0x1108:
		return "OS Resource error (no memory ?)";
	case 0x1109:
		return "CAPI not installed";
	case 0x110A:
		return "Controller does not support external equipment";
	case 0x110B:
		return "Controller does only support external equipment";

	/* error information concerning resource / coding problems */
	case 0x2001:
		return "Message not supported in current state";
	case 0x2002:
		return "Illegal Controller / PLCI / NCCI";
	case 0x2003:
		return "Out of PLCIs";
	case 0x2004:
		return "Out of NCCIs";
	case 0x2005:
		return "Out of LISTEN requests";
	case 0x2006:
		return "Out of FAX resources (protocol T.30)";
	case 0x2007:
		return "Illegal message parameter coding";

	/* error information concerning requested services */
	case 0x3001:
		return "B1 protocol not supported";
	case 0x3002:
		return "B2 protocol not supported";
	case 0x3003:
		return "B3 protocol not supported";
	case 0x3004:
		return "B1 protocol parameter not supported";
	case 0x3005:
		return "B2 protocol parameter not supported";
	case 0x3006:
		return "B3 protocol parameter not supported";
	case 0x3007:
		return "B protocol combination not supported";
	case 0x3008:
		return "NCPI not supported";
	case 0x3009:
		return "CIP Value unknown";
	case 0x300A:
		return "Flags not supported (reserved bits)";
	case 0x300B:
		return "Facility not supported";
	case 0x300C:
		return "Data length not supported by current protocol";
	case 0x300D:
		return "Reset procedure not supported by current protocol";
	case 0x300E:
		return "TEI assignment failed or supplementary service not supported";
	case 0x3010:
		return "Request not allowed in this state";

	/* informations about the clearing of a physical connection */
	case 0x3301:
		return "Protocol error layer 1 (broken line or B-channel removed by signalling protocol)";
	case 0x3302:
		return "Protocol error layer 2";
	case 0x3303:
		return "Protocol error layer 3";
	case 0x3304:
		return "Another application got that call";

	/* T.30 specific reasons */
	case 0x3311:
		return "Connecting not successful (remote station is no FAX G3 machine)";
	case 0x3312:
		return "Connecting not successful (training error)";
	case 0x3313:
		return "Disconnected before transfer (remote station does not support transfer mode, e.g. resolution)";
	case 0x3314:
		return "Disconnected during transfer (remote abort)";
	case 0x3315:
		return "Disconnected during transfer (remote procedure error, e.g. unsuccessful repetition of T.30 commands)";
	case 0x3316:
		return "Disconnected during transfer (local tx data underrun)";
	case 0x3317:
		return "Disconnected during transfer (local rx data overflow)";
	case 0x3318:
		return "Disconnected during transfer (local abort)";
	case 0x3319:
		return "Illegal parameter coding (e.g. SFF coding error)";

	/* disconnect causes from the network according to ETS 300 102-1/Q.931 */
	case 0x3481:
		return "Unallocated (unassigned) number";
	case 0x3482:
		return "No route to specified transit network";
	case 0x3483:
		return "No route to destination";
	case 0x3486:
		return "Channel unacceptable";
	case 0x3487:
		return "Call awarded and being delivered in an established channel";
	case 0x3490:
		return "Normal call clearing";
	case 0x3491:
		return "User busy";
	case 0x3492:
		return "No user responding";
	case 0x3493:
		return "No answer from user (user alerted)";
	case 0x3495:
		return "Call rejected";
	case 0x3496:
		return "Number changed";
	case 0x349A:
		return "Non-selected user clearing";
	case 0x349B:
		return "Destination out of order";
	case 0x349C:
		return "Invalid number format";
	case 0x349D:
		return "Facility rejected";
	case 0x349E:
		return "Response to STATUS ENQUIRY";
	case 0x349F:
		return "Normal, unspecified";
	case 0x34A2:
		return "No circuit / channel available";
	case 0x34A6:
		return "Network out of order";
	case 0x34A9:
		return "Temporary failure";
	case 0x34AA:
		return "Switching equipment congestion";
	case 0x34AB:
		return "Access information discarded";
	case 0x34AC:
		return "Requested circuit / channel not available";
	case 0x34AF:
		return "Resources unavailable, unspecified";
	case 0x34B1:
		return "Quality of service unavailable";
	case 0x34B2:
		return "Requested facility not subscribed";
	case 0x34B9:
		return "Bearer capability not authorized";
	case 0x34BA:
		return "Bearer capability not presently available";
	case 0x34BF:
		return "Service or option not available, unspecified";
	case 0x34C1:
		return "Bearer capability not implemented";
	case 0x34C2:
		return "Channel type not implemented";
	case 0x34C5:
		return "Requested facility not implemented";
	case 0x34C6:
		return "Only restricted digital information bearer capability is available";
	case 0x34CF:
		return "Service or option not implemented, unspecified";
	case 0x34D1:
		return "Invalid call reference value";
	case 0x34D2:
		return "Identified channel does not exist";
	case 0x34D3:
		return "A suspended call exists, but this call identity does not";
	case 0x34D4:
		return "Call identity in use";
	case 0x34D5:
		return "No call suspended";
	case 0x34D6:
		return "Call having the requested call identity has been cleared";
	case 0x34D8:
		return "Incompatible destination";
	case 0x34DB:
		return "Invalid transit network selection";
	case 0x34DF:
		return "Invalid message, unspecified";
	case 0x34E0:
		return "Mandatory information element is missing";
	case 0x34E1:
		return "Message type non-existent or not implemented";
	case 0x34E2:
		return "Message not compatible with call state or message type non-existent or not implemented";
	case 0x34E3:
		return "Information element non-existent or not implemented";
	case 0x34E4:
		return "Invalid information element contents";
	case 0x34E5:
		return "Message not compatible with call state";
	case 0x34E6:
		return "Recovery on timer expiry";
	case 0x34EF:
		return "Protocol error, unspecified";
	case 0x34FF:
		return "Interworking, unspecified";

	/* B3 protocol 7 (Modem) */
	case 0x3500:
		return "Normal end of connection";
	case 0x3501:
		return "Carrier lost";
	case 0x3502:
		return "Error on negotiation, i.e. no modem with error correction at other end";
	case 0x3503:
		return "No answer to protocol request";
	case 0x3504:
		return "Remote modem only works in synchronous mode";
	case 0x3505:
		return "Framing fails";
	case 0x3506:
		return "Protocol negotiation fails";
	case 0x3507:
		return "Other modem sends wrong protocol request";
	case 0x3508:
		return "Sync information (data or flags) missing";
	case 0x3509:
		return "Normal end of connection from the other modem";
	case 0x350a:
		return "No answer from other modem";
	case 0x350b:
		return "Protocol error";
	case 0x350c:
		return "Error on compression";
	case 0x350d:
		return "No connect (timeout or wrong modulation)";
	case 0x350e:
		return "No protocol fall-back allowed";
	case 0x350f:
		return "No modem or fax at requested number";
	case 0x3510:
		return "Handshake error";

	/* error info concerning the requested supplementary service */
	case 0x3600:
		return "Supplementary service not subscribed";
	case 0x3603:
		return "Supplementary service not available";
	case 0x3604:
		return "Supplementary service not implemented";
	case 0x3606:
		return "Invalid served user number";
	case 0x3607:
		return "Invalid call state";
	case 0x3608:
		return "Basic service not provided";
	case 0x3609:
		return "Supplementary service not requested for an incoming call";
	case 0x360a:
		return "Supplementary service interaction not allowed";
	case 0x360b:
		return "Resource unavailable";

	/* error info concerning the context of a supplementary service request */
	case 0x3700:
		return "Duplicate invocation";
	case 0x3701:
		return "Unrecognized operation";
	case 0x3702:
		return "Mistyped argument";
	case 0x3703:
		return "Resource limitation";
	case 0x3704:
		return "Initiator releasing";
	case 0x3705:
		return "Unrecognized linked-ID";
	case 0x3706:
		return "Linked response unexpected";
	case 0x3707:
		return "Unexpected child operation";

	/* Line Interconnect */
	case 0x3800:
		return "PLCI has no B-channel";
	case 0x3801:
		return "Lines not compatible";
	case 0x3802:
		return "PLCI(s) is (are) not in any or not in the same interconnection";

	default:
		return NULL;
	}
}

