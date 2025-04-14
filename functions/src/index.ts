import {gemini20Flash, googleAI} from "@genkit-ai/googleai";
import {onCallGenkit} from "firebase-functions/https";
import {genkit, z} from "genkit/beta";
import {defineSecret} from "firebase-functions/params";
import {jsonrepair} from "jsonrepair";

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

const subtopicSchema = z.object({
  subtopicName: z.string(),
  description: z.string(),
});

const topicSchema = z.object({
  topic: z.object({
    topicName: z.string(),
    subtopics: z.array(subtopicSchema),
  }),
});

const outputSchema = z.array(topicSchema);

const processCourseMaterialFlow = ai.defineFlow(
  {
    name: "processCourseMaterial",
    inputSchema: courseSchema,
    outputSchema: outputSchema,
  },
  async (course) => {
    try {
      const {text} = await ai.generate({
        prompt: [
          {media: {url: course.material}},
          {
            text: `Analyze the given course material and extract *all topics and subtopics* comprehensively. For each subtopic, return the following JSON structure:

[
  {
    "topic": {
      "topicName": string,
      "subtopics": [
        {
          "subtopicName": string,
          "description": string (a detailed explanation of the subtopic),
          }
        ]
        }
      ]
    }
  }
]

Requirements:
- Include **all major and minor topics** covered in the document
- Every subtopic must have a well-written description.
- Ensure JSON is complete, valid, and contains no extra formatting, no Markdown, no backticks — just raw JSON
- Be concise but complete. Avoid skipping or collapsing sections.

Respond with nothing but the full JSON array.
`,
          },
        ],
      });
      try {
        const repairedJson = jsonrepair(text); // Repair JSON
        const parsed = JSON.parse(repairedJson); // Parse repaired JSON
        return parsed;
      } catch (err) {
        throw new Error("Unable to parse Genkit response as JSON.");
      }
    } catch (err) {
      throw new Error("Failed to process PDFs.");
    }
  }
);

const subtopicQuizSchema = z.object({
  courseMaterial: z.string(),
  subtopicName: z.string(),
  subtopicDescription: z.string(),
});

const quizOutputSchema = z.array(
  z.object({
    questionText: z.string(),
    correctOption: z.string(),
    options: z.array(z.string()),
  })
);

const generateSubtopicQuizFlow = ai.defineFlow(
  {
    name: "generateSubtopicQuiz",
    inputSchema: subtopicQuizSchema,
    outputSchema: quizOutputSchema,
  },
  async (input) => {
    try {
      const {text} = await ai.generate({
        prompt: [
          {media: {url: input.courseMaterial}},
          {
            text: `Using the provided course material and the subtopic below, generate a minimum of 10 high-quality multiple choice questions in JSON format. Each question should contain the following fields:

{
  "questionText": string,
  "correctOption": string,
  "options": string[]
}

Subtopic: ${input.subtopicName}
Description: ${input.subtopicDescription}

Only return a raw JSON array of questions. No markdown, comments, or extra text.
`,
          },
        ],
      });

      const repairedJson = jsonrepair(text);
      const parsed = JSON.parse(repairedJson);
      return parsed;
    } catch (err) {
      throw new Error("Failed to generate subtopic quiz.");
    }
  }
);

export const processCourseMaterial = onCallGenkit({
  secrets: [geminiKey],
},
processCourseMaterialFlow,
);

export const generateSubtopicQuiz = onCallGenkit({
  secrets: [geminiKey],
},
generateSubtopicQuizFlow,
);
