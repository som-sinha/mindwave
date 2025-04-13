import {gemini20Flash, googleAI} from "@genkit-ai/googleai";
import {onCallGenkit} from "firebase-functions/https";
import {genkit, z} from "genkit/beta";
import { defineSecret } from "firebase-functions/params";

// instantiate Genkit
const geminiKey = defineSecret("GEMINI_API_KEY");

const ai = genkit({
  plugins: [googleAI()],
  model: gemini20Flash,
});

const courseSchema = z.object({
  courseName: z.string(),
  subject: z.string(),
  material: z.string(),
});

const processCourseMaterialFlow = ai.defineFlow(
  {
    name: "processCourseMaterial",
    inputSchema: courseSchema,
    outputSchema: z.string(),
  },
  async (course) => {
    try {
      const { text } = await ai.generate(
        {prompt:
          [{media: {url: course.material}}, {text: `Return a json file with a list of topics and subtopics covered for Course: ${course.courseName} in Subject: ${course.subject}`}],
        }
      );
      return text;
    } catch (err) {
      console.error("Error processing PDFs:", err);
      throw new Error("Failed to process PDFs.");
    }
  }
);

exports.processCourseMaterial = onCallGenkit({
  // [START bind-secrets]
  // Bind the Gemini API key secret parameter to the function.
  secrets: [geminiKey],
  // [END bind-secrets]
},
// Pass in the genkit flow.
processCourseMaterialFlow,
);

