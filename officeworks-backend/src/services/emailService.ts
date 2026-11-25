
import dotenv from "dotenv";
import { Resend } from "resend";

dotenv.config();

interface EnquiryEmail {
    productId: number;
    productName: string;
    customerName: string;
    customerEmail: string;
    customerPhone: string;
    message: string;
}

export async function sendEnquiryEmail(
    enquiry: EnquiryEmail
): Promise<void> {
    const emailMode = process.env.EMAIL_MODE || "console";
    const salesEmail = process.env.SALES_EMAIL;

    if (!salesEmail) {
        throw new Error("SALES_EMAIL is not configured.");
    }

    const subject = `New Product Enquiry - ${enquiry.productName}`;

    const emailText = `
New Product Enquiry

Product Details
---------------
Product ID: ${enquiry.productId}
Product Name: ${enquiry.productName}

Customer Details
----------------
Name: ${enquiry.customerName}
Email: ${enquiry.customerEmail}
Phone: ${enquiry.customerPhone}

Message
-------
${enquiry.message}
`;

    // Local development mode
    if (emailMode === "console") {
        console.log("========== ENQUIRY EMAIL ==========");
        console.log("To:", salesEmail);
        console.log("Subject:", subject);
        console.log(emailText);
        console.log("===================================");

        return;
    }

    // Resend email provider
    if (emailMode === "resend") {
        const apiKey = process.env.RESEND_API_KEY;

        if (!apiKey) {
            throw new Error("RESEND_API_KEY is not configured.");
        }

        const resend = new Resend(apiKey);

        const { data, error } = await resend.emails.send({
            from: "Officeworks Catalogue <onboarding@resend.dev>",
            to: salesEmail,
            replyTo: enquiry.customerEmail,
            subject,
            text: emailText
        });

        if (error) {
            console.error("Resend API error:", error);
            throw new Error(error.message);
        }

        console.log("Enquiry email accepted by Resend:", data?.id);
        return;
    }

    throw new Error(`Unsupported EMAIL_MODE: ${emailMode}`);
}
