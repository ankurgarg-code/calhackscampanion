import os
from langchain import hub
from langchain_chroma import Chroma
from langchain_community.document_loaders import TextLoader
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain.embeddings import HuggingFaceEmbeddings
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_google_vertexai import ChatVertexAI
from langchain.chains import ConversationalRetrievalChain
from langchain_core.prompts import PromptTemplate
from langchain.memory import ConversationBufferMemory

# Set environment variables (Google API keys, etc.)
os.environ["GOOGLE_API_KEY"] = 'YOUR_GOOGLE_API_KEY'
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/path/to/your/credentials.json"

# Initialize models and embeddings
llm = ChatVertexAI(model="gemini-1.5-flash")
embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

# Load, chunk, and index documents
loader = TextLoader('Data Collection/corpus_combined.txt')
docs = loader.load()
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
splits = text_splitter.split_documents(docs)
vectorstore = Chroma.from_documents(documents=splits, embedding=embeddings, persist_directory='./test')
retriever = vectorstore.as_retriever()

# Define the prompt template
template = """Use the following pieces of context to answer the question at the end.
If you don't know the answer, just say that you don't know, don't try to make up an answer.
If the question has a sense of urgency, prioritize answering with clarity and in maximum 3 sentences.
If the question is more general, provide a more detailed explanation in 5-7 sentences.
If you do not know the answer, you can provide a general response from what you know.
Always say "thanks for asking!" at the end of the answer.

{context}

Question: {question}

Helpful Answer:"""

custom_rag_prompt = PromptTemplate.from_template(template)

# Create memory object for chat history
memory = ConversationBufferMemory(
    memory_key="chat_history",
    return_messages=True
)

# Create ConversationalRetrievalChain
qa_chain = ConversationalRetrievalChain.from_llm(
    llm=llm,
    retriever=retriever,
    memory=memory,
    combine_docs_chain_kwargs={"prompt": custom_rag_prompt}
)

def get_answer(question):
    result = qa_chain({"question": question})
    return result['answer']
